package com.gt.board.util;

import java.io.File;
import java.nio.file.Files;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

import com.gt.board.vo.AttachFile;

public class FileUtil {
    private static final Logger logger = Logger.getLogger(FileUtil.class);

    public FileUtil() {
    }

    /** 임시 폴더의 파일이 본문에 포함될 경우 실제 폴더로 이동
     *  @param content 본문 내용(null일시 본문 검사 제외)
     *  @param tempFolder 임시 폴더명
     *  @param folderName 파일이 옮겨질 실제 폴더명
     *  @param files 임시폴더에 업로드된 파일 목록
     *  @param path localhost 복사 **/
    public void moveUploadedFiles(String content, String tempFolder, String folderName, List<AttachFile> files) {
        if (files == null || files.size() == 0) {
            return;
        }

        AttachFile[] fileArray = files.toArray(new AttachFile[files.size()]);
        for (AttachFile file : fileArray) {
            if (file.getFullPath() == null) {
                continue;
            }

            String newPath = file.getFullPath().replace(tempFolder, folderName);

            // 본문 검사
            if (content == null || content.indexOf(file.getNewName()) != -1) {
                moveFile(file.getFullPath(), newPath);
            } else {
                deleteFile(file.getFullPath());
                files.remove(file);
            }
        }
    }

    /** 업로드된 파일 삭제
     *  @param files 세션에 기록된 업로드된 파일 목록
     *  @param url 삭제할 파일의 url **/
    public boolean deleteUploadedFile(List<AttachFile> files, String url) {
        try {
            if (files == null || files.size() == 0) {
                return false;
            }

            for (AttachFile file : files) {
                if (url.equals(file.getUrl())) {
                    String fullPath = file.getFullPath();
                    deleteFile(fullPath);
                    files.remove(file);
                    return true;
                }
            }
        } catch (Exception e) {
            logger.warn("deleteUploadedFile", e);
        }
        return false;
    }

    /** 업로드된 파일 목록 일괄 삭제
     *  @param files 세션에 기록된 업로드된 파일 목록 **/
    public boolean deleteUploadedFiles(List<AttachFile> files) {
        try {
            if (files == null || files.size() == 0) {
                return false;
            }

            // TODO protected일때만 remove하면 다른페이지 이동시 session에 그대로 있는다.
            AttachFile[] fileArray = files.toArray(new AttachFile[files.size()]);
            for (AttachFile file : fileArray) {
                if (file.isProtected()) {
                    file.setProtected(false);
                } else {
                    deleteFile(file.getFullPath());
                    files.remove(file);
                }
            }
            return true;
        } catch (Exception e) {
            logger.warn("deleteUploadedFiles", e);
        }
        return false;
    }

    /** 파일 크기 취득
     *  @param path 파일 경로 **/
    public long getFileSize(String path) {
        if (path != null) {
            File file = new File(path);
            if (file.exists()) {
                return file.length();
            }
        }
        return 0;
    }

    /** 폴더와 하위 폴더/파일 복사
     *  @param srcPath 복사할 폴더 경로
     *  @param newPath 생성될 폴더 경로 **/
    public void copyFolder(String srcPath, String newPath) {
        if (srcPath == null || newPath == null) {
            return;
        }
        try {
            File srcDir = new File(srcPath);
            File newDir = new File(newPath);
            if (!srcDir.exists()) {
                return;
            }
            if (newDir.exists()) {
                deleteFolder(newPath);
            }
            FileUtils.copyDirectory(srcDir, newDir);
        } catch (Exception e) {
            logger.warn("copyFolder", e);
        }
    }

    /** 해당 폴더 및 하위 폴더/파일 삭제
     *  @param path 삭제할 폴더 경로 **/
    public void deleteFolder(String path) {
        if (path == null) {
            return;
        }
        File folder = new File(path);
        if (!folder.exists()) {
            return;
        }

        if (folder.isDirectory()) {
            File[] children = folder.listFiles();
            for (File child : children) {
                deleteFolder(child.getPath());
            }
        }
        folder.delete();
    }

    // 파일 이동
    private void moveFile(String srcPath, String newPath) {
        if (srcPath == null || newPath == null) {
            return;
        } else if (srcPath.equals(newPath)) {
            return;
        }
        try {
            // 원본 파일이 존재하는지 확인
            File srcFile = new File(srcPath);
            if (!srcFile.exists()) {
                return;
            }

            // 새로운 파일 경로중 최종 폴더경로 까지 취득
            String folderPath = newPath.substring(0, newPath.lastIndexOf(File.separator));

            // 새로운 폴더 생성
            File folder = new File(folderPath);
            if (!folder.exists()) {
                folder.mkdirs();
            }

            // 파일 이동
            File moveFile = new File(newPath);
            if (moveFile.exists()) {
                moveFile.delete();
            }
            Files.move(srcFile.toPath(), moveFile.toPath());
        } catch (Exception e) {
            logger.warn("moveFile", e);
        }
    }

    // 파일 삭제
    private void deleteFile(String path) {
        if (path == null) {
            return;
        }
        File file = new File(path);
        if (file.exists()) {
            file.delete();
        }
    }

}
