package com.debashish;


import com.debashish.config.DataSourceConfig;
import com.debashish.service.TableScannerService;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;


/**
 * java -cp TableScanner-1.0-SNAPSHOT.jar com.debashish.Main
 */
public class Main {
    public static void main(String[] args) {
        try (AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(DataSourceConfig.class)) {
            // Retrieve the service bean from the context
            TableScannerService yourEntityService = context.getBean(TableScannerService.class);
            // Call the service method
            List<List<String>> listList = yourEntityService.execute("debashish", "789 Pine St");
            try {
                Workbook workbook = yourEntityService.createWorkbookFromCsvList(listList);
                FileOutputStream fileOut = new FileOutputStream("output.xlsx");
                workbook.write(fileOut);
                fileOut.close();
                System.out.println("Excel file has been created successfully.");
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }


}