import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

class FetchPreview {
  Future<Map<String, dynamic>> fetch(String url) async {
    final client = Client();
    final response = await client.get(Uri.parse(_validateUrl(url)));
    final document = parse(response.body);

    String description = '', title = '', image = '', appleIcon = '', favIcon = '';

    List<Element> elements = document.getElementsByTagName('meta');
    final List<Element> linkElements = document.getElementsByTagName('link');

    elements.forEach((tmp) {
      if (tmp.attributes['property'] == 'og:title') {
        //fetch seo title
        title = tmp.attributes['content'] ?? '';
      }
      else {
        title = '';
      }
      //if seo title is empty then fetch normal title
      if (title.isEmpty) {
        title = document.getElementsByTagName('title')[0].text;
      }

      //fetch seo description
      if (tmp.attributes['property'] == 'og:description') {
        description = tmp.attributes['content'] ?? '';
      }
      else {
        description = '';
      }
      //if seo description is empty then fetch normal description.
      if (description.isEmpty) {
        //fetch base title
        if (tmp.attributes['name'] == 'description') {
          description = tmp.attributes['content'] ?? '';
        }
      }


      //fetch image
      if (tmp.attributes['property'] == 'og:image') {
        image = tmp.attributes['content'] ?? '';
      }
    });

    linkElements.forEach((tmp) {
      if (tmp.attributes['rel'] == 'apple-touch-icon') {
        appleIcon = tmp.attributes['href'] ?? '';
      }
      if (tmp.attributes['rel']?.contains('icon') == true) {
        favIcon = tmp.attributes['href'] ?? '';
      }
    });

    return {
      'title': title,
      'description': description,
      'image': image,
      'appleIcon': appleIcon,
      'favIcon': favIcon,
    };
  }

  _validateUrl(String url) {
    if (url.startsWith('http://') == true || url.startsWith('https://') == true) {
      return url;
    }
    else {
      return 'http://$url';
    }
  }
}



// Widget _buildPreviewWidget(Map<String, dynamic> data, String url) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.lightGreen[100],
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: <Widget>[
//               (data['image'] != null && data['image'].isNotEmpty)
//                   ? Image.network(
//                       data['image'],
//                       height: 100,
//                       width: 100,
//                       fit: BoxFit.cover,
//                     )
//                   : Container(),
//               Flexible(
//                   child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       data['title'],
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.black),
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       data['description'],
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Row(
//                       children: <Widget>[
//                         // (data['favIcon'] != null) ? Image.network(data['favIcon'], height: 12, width: 12,) : Container(),
//                         SizedBox(
//                           width: 4,
//                         ),
//                         Text(url,
//                             style: TextStyle(color: Colors.grey, fontSize: 12))
//                       ],
//                     )
//                   ],
//                 ),
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }