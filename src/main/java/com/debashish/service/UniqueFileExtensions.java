import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.HashSet;
import java.util.Set;

public class UniqueFileExtensions {

    public static void main(String[] args) {
   /*     if (args.length != 1) {
            System.err.println("Usage: java UniqueFileExtensions <folder_path>");
            System.exit(1);
        }*/

        String folderPath = args[0];//"E:\\study\\spring-boot\\microservices\\microservice1"; //args[0];

        try {
            Set<String> uniqueExtensions = new HashSet<>();
            Files.walkFileTree(Paths.get(folderPath), new SimpleFileVisitor<Path>() {
                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                    String extension = getFileExtension(file);
                    uniqueExtensions.add(extension.toLowerCase()); // case-insensitive comparison
                    return FileVisitResult.CONTINUE;
                }
            });

            System.out.println("Unique file extensions in the folder:");
            for (String extension : uniqueExtensions) {
                System.out.println(extension);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static String getFileExtension(Path file) {
        String fileName = file.getFileName().toString();
        int lastDotIndex = fileName.lastIndexOf(".");
        if (lastDotIndex > 0) {
            return fileName.substring(lastDotIndex + 1);
        }
        return ""; // No file extension
    }
}
