package com.debashish.service;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.stereotype.Service;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class TableScannerService {
    @Value("classpath:data.txt")
    private Resource resource;

    public List<String> readLinesFromFile() {
        List<String> lines = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(resource.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return lines;
    }
    public List<List<String>> execute(String owner, String searchString) {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("oracle.jdbc.OracleDriver");
        dataSource.setUrl("jdbc:oracle:thin:@//localhost:1521/xe");
        dataSource.setUsername("debashish");
        dataSource.setPassword("debashish");
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        List<String> tableNames = jdbcTemplate.queryForList("SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = ?",
                String.class, owner.toUpperCase());
        List<List<String>> listList = new ArrayList<>();
        listList.add(Arrays.asList("Search Text","Table Name","Column Name","Owner"));
        for (String tableName : tableNames) {
            //
            List<String> columnNames = jdbcTemplate.queryForList(
                    "SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER = ? AND TABLE_NAME = ?",
                    String.class, owner.toUpperCase(), tableName);

            for (String columnName : columnNames) {
                String query = "SELECT DATA_TYPE FROM ALL_TAB_COLUMNS WHERE OWNER = ? AND TABLE_NAME = ? AND COLUMN_NAME = ?";
                String dataType = jdbcTemplate.queryForObject(query, String.class, owner.toUpperCase(), tableName.toUpperCase(), columnName.toUpperCase());
                assert dataType != null;
                if (dataType.equalsIgnoreCase("VARCHAR") || dataType.equalsIgnoreCase("VARCHAR2") || dataType.equalsIgnoreCase("CHAR")) {

                    int count = jdbcTemplate.queryForObject(
                            "SELECT COUNT(*) FROM " + owner + "." + tableName + " WHERE " + columnName + " = ?",
                            Integer.class, searchString);
                    if (count > 0) {
                        listList.add(
                                Arrays.asList(searchString, tableName, columnName, owner));
                    }
                }
            }
        }
        return listList;
    }

    public Workbook createWorkbookFromCsvList(List<List<String>> csvData) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Sheet1");

        // Create a font for the header
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);

        // Create a cell style with borders and bold header font
        CellStyle headerCellStyle = workbook.createCellStyle();
        headerCellStyle.setBorderBottom(BorderStyle.THIN);
        headerCellStyle.setBottomBorderColor(IndexedColors.BLACK.getIndex());
        headerCellStyle.setBorderRight(BorderStyle.THIN);
        headerCellStyle.setRightBorderColor(IndexedColors.BLACK.getIndex());
        headerCellStyle.setFont(headerFont);

        // Create the header row
        Row headerRow = sheet.createRow(0);
        List<String> headers = csvData.get(0);
        for (int i = 0; i < headers.size(); i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers.get(i));
            cell.setCellStyle(headerCellStyle);
        }

        // Create the data rows
        CellStyle dataCellStyle = workbook.createCellStyle();
        dataCellStyle.setBorderBottom(BorderStyle.THIN);
        dataCellStyle.setBottomBorderColor(IndexedColors.BLACK.getIndex());
        dataCellStyle.setBorderRight(BorderStyle.THIN);
        dataCellStyle.setRightBorderColor(IndexedColors.BLACK.getIndex());

        for (int i = 1; i < csvData.size(); i++) {
            Row dataRow = sheet.createRow(i);
            List<String> data = csvData.get(i);
            for (int j = 0; j < data.size(); j++) {
                Cell cell = dataRow.createCell(j);
                cell.setCellValue(data.get(j));
                cell.setCellStyle(dataCellStyle);
            }
        }

        return workbook;
    }
}