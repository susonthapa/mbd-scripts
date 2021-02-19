import java.io.File
import java.lang.StringBuilder

data class Module(
    val name: String,
    val version: String,
    val position: Int
)

val versionPrefix = "versions."
val versionFileName = "versions.gradle"
val targetBranch = "develop"
val modulePrefix = ""

fun main(args: Array<String>) {
    println("running version increment")
    val workingDir = System.getProperty("user.dir")
    println("workingDir: $workingDir")
    val defaultModule = if (args.isNotEmpty()) {
        args[0]
    } else {
        null
    }

    val delimiter = "@f1soft@"
    val targetPath = "$workingDir/$versionFileName"
    val changedFiles = getChangedFilesFromBaseCommit(workingDir)
    println("changedFiles: $changedFiles\n")
    val versionList = File(targetPath).readLines()
    val parsedModules = getParsedModules(delimiter, versionList)
    println("parsedModules:")
    parsedModules.forEach {
        println("\t$it")
    }

    val changedModules = getChangedModulesName(changedFiles).toMutableList()
    if (defaultModule != null) {
        // check if already have changes in the default module, otherwise fake the changes to trigger version update
        val defaultModuleNotPresent = changedModules.filter { it == defaultModule }.isEmpty()
        if (defaultModuleNotPresent) {
            println("adding default module: $defaultModule\n")
            changedModules.add(defaultModule)
        }
    }
    println("changedModules:")
    changedModules.forEach {
        println("\t$it")
    }
    val changedModulesDetails =
        updateVersions(versionList, parsedModules, changedModules, targetPath)
    if (changedModules.isEmpty()) {
        println("no modules changed!")
    } else {
        println("commit message: $changedModulesDetails")
        saveChangeLog(changedModulesDetails)
    }
}

fun saveChangeLog(changedModules: String) {
    val outputFile = File("changed_modules.txt")
    val writer = outputFile.outputStream().bufferedWriter()
    writer.write(changedModules)
    writer.close()
}

fun updateVersions(
    versionList: List<String>,
    parsedModules: List<Module>,
    changedModules: List<String>,
    outputFilePath: String
): String {
    val updatedVersions = StringBuilder("updated versions: \n")
    val outputList = versionList.toMutableList()
    // loop through all the parsed modules
    parsedModules.forEach {
        val isModuleChanged = changedModules.find {module -> module.contains(it.name) } != null
        // check if this module is changed
        if (isModuleChanged) {
            // increment the versio
            val newVersion = getIncrementedVersion(it.version)
            val newModule = "$versionPrefix${it.name} = \"$newVersion\""
            outputList[it.position] = newModule
            println("${it.name}: ${it.version} ----> $newVersion")
            updatedVersions.append("\t${it.name}: ${it.version} ----> $newVersion\n")
        }
    }

    val outputFile = File(outputFilePath)
    val writer = outputFile.outputStream().bufferedWriter()
    outputList.forEach {
        writer.write(it)
        writer.newLine()
    }
    writer.close()
    // remove last empty new line
    var trimmerVersions = updatedVersions.toString()
    trimmerVersions = if (trimmerVersions.lastIndexOf("\n") > 0) {
        trimmerVersions.substring(0, trimmerVersions.lastIndexOf("\n"))
    } else {
        trimmerVersions
    }

    return trimmerVersions
}

fun getIncrementedVersion(version: String): String {
    val majorIndex = version.indexOf('.')
    var major = version.substring(0, majorIndex).toInt()
    val versionPart = version.substring(majorIndex + 1)
    val minorIndex = versionPart.indexOf('.')
    var minor = versionPart.substring(0, minorIndex).toInt()
    var patch = versionPart.substring(minorIndex + 1).toInt()

    if (patch > 998) {
        patch = 0
        minor++
    } else {
        patch++
    }
    if (minor > 99) {
        minor = 0
        major++
    }

    return "$major.$minor.$patch"
}

fun getDelimiterPosition(versionList: List<String>, delimiter: String): Pair<Int, Int> {
    var delimiterCount = 0
    var startIndex = 0
    var endIndex = 0
    for (i in versionList.indices) {
        if (versionList[i].contains(delimiter)) {
            delimiterCount++
            if (delimiterCount == 1) {
                startIndex = i
            }
            if (delimiterCount == 2) {
                endIndex = i
                break
            }
        }
    }

    return Pair(startIndex, endIndex)
}


fun getParsedModules(delimiter: String, versionsList: List<String>): List<Module> {
    val delimiterRange = getDelimiterPosition(versionsList, delimiter)
    val modules = mutableListOf<Module>()
    for (i in (delimiterRange.first + 1) until delimiterRange.second) {
        val version = getVersionString(versionsList[i])
        val module = Module(version.first.trim(), version.second.trim(), i)
        modules.add(module)
    }

    return modules
}

fun getVersionString(version: String): Pair<String, String> {
    val sanitizedVersion = if (version.startsWith("//")) {
        version.replace("//", "")
    } else {
        version
    }
    val versionList = sanitizedVersion.split("=")
    return Pair(versionList[0].substring(versionPrefix.length), versionList[1].replace("\"", ""))
}

fun getChangedModulesName(changedFiles: List<String>): List<String> {
    val settingsFile = File("../settings.gradle")
    val loadedModules = settingsFile.inputStream().bufferedReader().readLines()
        .filter {
            it.contains("include")
        }
        .map {
            it.substring(it.indexOf(":") + 1, it.length - 1)
                .replace(":", "/")
        }
    

    return loadedModules.filter {
        changedFiles.find { file ->
            file.contains(it)
        } != null
    }.map {
        if (modulePrefix.isEmpty()) {
            it
        } else {
            val lastSlash = it.lastIndexOf("/")
            it.substring(lastSlash + 1)
        }
    }
}

fun getChangedFilesFromBaseCommit(workingDir: String): List<String> {
    // get the changed files from the base of the current branch to the HEAD
    val process = Runtime.getRuntime()
        .exec("git diff --name-only $targetBranch..", arrayOf(), File(workingDir))
    return process.inputStream.bufferedReader().readLines()
}
