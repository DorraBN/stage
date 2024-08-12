import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

void main() {
  runApp(ConvertToPdfPage());
}

class ConvertToPdfPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create PDF Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is some content that will be saved as a PDF.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pdf = pw.Document();

                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) => pw.Center(
                      child: pw.Text('Hello World! This is a PDF document.'),
                    ),
                  ),
                );

                // Save the PDF to a file
                await Printing.sharePdf(
                    bytes: await pdf.save(), filename: 'my_document.pdf');
              },
              child: Text('Convert to PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
