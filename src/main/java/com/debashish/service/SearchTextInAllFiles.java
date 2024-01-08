import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * javac SearchTextInAllFiles.java
 * java Scratch "E:\\study\\spring-boot\\microservices\\microservice1" "E:\\study\\spring-boot\\microservices\\searchText.txt"
 * java name search C:\path\to\your\project C:\path\to\your\citynames.txt
 */
class SearchTextInAllFiles {
    public static void main(String[] args) {
    /*    if (args.length != 2) {
            System.err.println("Usage: java name search <project_folder_path> <city_names_file_path>");
            System.exit(1);
        }*/

        String projectFolderPath = args[0]; // "E:\\study\\spring-boot\\microservices\\microservice1";
        String cityNamesFilePath = args[1]; //"E:\\study\\spring-boot\\microservices\\searchText.txt" ;

        try {
            List<String> cityNames = Files.readAllLines(Paths.get(cityNamesFilePath));
            Files.walkFileTree(Paths.get(projectFolderPath), new SimpleFileVisitor<Path>() {
                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                    if (isFileOfType(file, ".java", ".properties", ".sql", ".xml")) {
                        searchCityNamesInFile(file, cityNames);
                    }
                    return FileVisitResult.CONTINUE;
                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static boolean isFileOfType(Path file, String... extensions) {
        String fileName = file.getFileName().toString();
        for (String extension : extensions) {
            if (fileName.endsWith(extension)) {
                return true;
            }
        }
        return false;
    }

    private static void searchCityNamesInFile(Path file, List<String> cityNames) throws IOException {
        String content = new String(Files.readAllBytes(file), StandardCharsets.UTF_8);

        for (String cityName : cityNames) {
            Pattern pattern = Pattern.compile("\\b" + cityName + "\\b", Pattern.CASE_INSENSITIVE);
            Matcher matcher = pattern.matcher(content);

            if (matcher.find()) {
                System.out.println("City name '" + cityName + "' found in file: " + file.toString());
                break;  // Stop searching for this city name in the current file after the first match
            }
        }
    }
}
