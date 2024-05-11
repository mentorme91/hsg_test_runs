import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../themes.dart';
import 'image_viewer.dart';
import 'pdf_viewer.dart';
import '../services/storage_service.dart';

Widget previewPDF(
  File file,
  String title,
  String path,
  String url,
  BuildContext context,
) {
  int thisPages = 0;
  PDFViewController? thisController;
  int idx = 0;
  return Container(
      height: 150,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          PDFView(
            filePath: file.path,
            onRender: (pages) => thisPages = pages ?? 0,
            onViewCreated: (controller) => thisController = controller,
            onPageChanged: (indexPage, _) => idx = indexPage ?? 0,
            fitPolicy: FitPolicy.HEIGHT,
          ),
          Positioned(
            top: 50,
            right: 0,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 32),
                  onPressed: () {
                    final page = idx == 0 ? thisPages : idx - 1;
                    thisController?.setPage(page);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, size: 32),
                  onPressed: () {
                    final page = idx == thisPages - 1 ? 0 : idx + 1;
                    thisController?.setPage(page);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 5,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    bool pass = await downloadFile(path, title, url);
                    if (pass) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'File $title downloaded successfully',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'File $title failed to download',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.download,
                              color: Theme.of(context).colorScheme.background,
                              size: 19,
                            ),
                          ),
                          TextSpan(
                            text: 'Download',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PDFViewerPage(
                              file: file,
                              title: title,
                            )));
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          WidgetSpan(
                              child: Icon(
                            Icons.open_in_browser,
                            color: Theme.of(context).colorScheme.background,
                            size: 19,
                          )),
                          TextSpan(text: 'Open'),
                        ]),
                      )),
                ),
              ],
            ),
          ),
        ],
      ));
}

Widget previewImage(
    File file, String path, String title, String url, BuildContext context) {
  return Container(
    width: 350,
    height: 150,
    child: Stack(children: [
      Center(
        child: Image.file(
          file,
          fit: BoxFit.contain,
          width: 350,
          height: 200,
        ),
      ),
      Positioned(
        top: 50,
        left: 5,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                bool pass = await downloadFile(path, title, url);
                if (pass) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'File $title downloaded successfully',
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'File $title failed to download',
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.download,
                          color: Theme.of(context).colorScheme.background,
                          size: 19,
                        ),
                      ),
                      TextSpan(
                        text: 'Download',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImageViewerPage(image: file)));
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      WidgetSpan(
                          child: Icon(
                        Icons.open_in_browser,
                        color: Theme.of(context).colorScheme.background,
                        size: 19,
                      )),
                      TextSpan(text: 'Open'),
                    ]),
                  )),
            ),
          ],
        ),
      ),
    ]),
  );
}

Widget previewUnknown(
  File? file,
  String title,
  String path,
  String url,
  String extension,
  BuildContext context,
) {
  Map extensionImage = {
    '.pdf': 'pdf.png',
    '.docx': 'docx.jpeg',
    '.png': 'image.png',
    '.jpg': 'image.png',
    '.jpeg': 'image.png'
  };
  return Container(
    margin: EdgeInsets.all(10),
    decoration: boxDecoration(Theme.of(context), 20),
    child: ListTile(
        title: Text(title),
        subtitle: Text(
          'Tap to view',
          style: TextStyle(color: Colors.blue),
        ),
        leading: Image.asset(
            'assets/images/${extensionImage[extension] ?? 'pdf.png'}'),
        trailing: IconButton(
          onPressed: () async {
            bool pass = await StorageService().downloadFile(path, title);
            if (pass) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                      'File: $title has successfully downloaded.',
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
              );
            } else {
              try {
                launchUrl(Uri.parse(url));
              } catch (e) {
                print(e.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                        'File: $title failed to download.',
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                );
              }
            }
          },
          icon: Icon(Icons.download),
        ),
        onTap: () async {
          if (file == null) return;
          downloadFile(path, title, url);
        }),
  );
}

Widget previewFile(
  File? file,
  String title,
  String path,
  String url,
  String extension,
  BuildContext context,
) {
  if (file == null) {
    return const Center(
      child: Text('Failed to fetch the file you requested.'),
    );
  }
  if (extension == '.pdf') {
    return previewPDF(
      file,
      title,
      path,
      url,
      context,
    );
  } else if (extension == '.png' ||
      extension == '.jpg' ||
      extension == '.jpeg') {
    return previewImage(file, path, title, url, context);
  } else {
    return ListTile(
      title: Text(file.path.split('/').last),
      trailing: IconButton(
        icon: const Icon(Icons.download),
        onPressed: () {
          downloadFile(path, title, url);
        },
      ),
    );
  }
}


Future<bool> downloadFile(String path, String title, String url) async {
  bool pass = await StorageService().downloadFile(path, title);
  if (!pass) {
    try {
      pass = await launchUrl(Uri.parse(url));
    } catch (e) {
      pass = false;
    }
  }
  return pass;
}
