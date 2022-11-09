// import 'package:flutter/material.dart';

// resetPopup(BuildContext context)  {
//   showDialog(
//     context: context,
//     builder: ((context) {
//       return SimpleDialog(
//           backgroundColor: Colors.black,
//           title: const Center(
//             child: Text(
//               'Reset',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           children: [
//             const Center(
//               child: Text(
//                 'Are you sure you want to reset app?',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 20,),
//            Padding(
//              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: [
//                  ElevatedButton(onPressed: (){}, child: const Text('yes')),
//                   const SizedBox(width: 5,),
//                  ElevatedButton(onPressed: (){
                  
//                               vals = false;
                           
//                    Navigator.of(context).pop(context);
//                  }, child: const Text('Cancel')
//                  ),
//                ],
//              ),
//            )
//           ]);
//     }),
//   );
// }
// //  Navigator.of(context).pop(context);