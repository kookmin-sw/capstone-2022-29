// import "package:flutter/material.dart";

// class SearchPopup extends StatefulWidget {
//   SearchPopup({Key? key}) : super(key: key);

//   @override
//   State<SearchPopup> createState() => _SearchPopupState();
// }

// class _SearchPopupState extends State<SearchPopup> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (context) {
//           return StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return AlertDialog(
//                 content: SingleChildScrollView(
//                   child: ListBody(
//                     children: <Widget>[
//                       Container(child:searchBar(size,true)), 
//                       Slider(
//                         value: _currentSliderValue,
//                         max: 4,
//                         divisions: 3,
//                         onChanged: (double value) {
//                           setState(() {
//                             _currentSliderValue = value;
//                           });
//                         },
//                       ),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           primary: Color.fromRGBO(198, 228, 255, 1),
//                           onPrimary: Colors.black,
//                           minimumSize: Size(size.width*0.2, size.height*0.05),
//                           maximumSize: Size(size.width*0.2, size.height*0.05),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         onPressed: (){
//                           // Navigator.pop(context);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => TimelinePage()),
//                           );
//                         }, 
//                         child: Text("검색하기"),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//           );
//         }
//       )
//     );
//   }
// }