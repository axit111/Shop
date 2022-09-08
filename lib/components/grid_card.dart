import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../utils/custom_theme.dart';

class GridCard extends StatelessWidget {
  final index;
  final void Function() onPress;
  final Product product;

  const GridCard(
      {Key? key, this.index, required this.onPress, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),

        decoration: CustomTheme.getCardDecoration(),
        child: GestureDetector(
          onTap: onPress,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                Expanded(
                    flex: 7,
                    child: SizedBox(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl:
                            product.image,
                        fit: BoxFit.cover,
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              product.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Text(
                            product.price,
                            style: Theme.of(context).textTheme.headlineSmall,
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}

// class GridCard extends StatefulWidget {
//   const GridCard(
//       {Key? key, required int index, required Null Function() onPress})
//       : super(key: key);
//
//   @override
//   State<GridCard> createState() => _GridCardState();
// }
//
// class _GridCardState extends State<GridCard> {
//   int index = 0;
//   void Function()? onPress;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(10),
//         // margin: index! % 2 == 0
//         //     ? const EdgeInsets.only(left: 10,top: 10)
//         //     : const EdgeInsets.only(right: 10,bottom: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: CustomTheme.cardShadow,
//         ),
//         child: GestureDetector(
//           onTap: onPress,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Column(
//               children: [
//                 Expanded(
//                     flex: 3,
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: CachedNetworkImage(
//                         imageUrl: "https://www.istockphoto.com/photos/nike-shoes",
//                         fit: BoxFit.cover,
//                       ),
//                     )),
//                 Expanded(flex:1,child: Center(
//                   child: Column(
//                     children: [
//                       Padding(padding:const EdgeInsets.symmetric(vertical: 2),
//                         child: Text('Title',style: Theme.of(context).textTheme.headlineSmall,),),
//                       Text('Price',style: Theme.of(context).textTheme.headlineSmall,)
//                     ],
//                   ),
//                 ))
//               ],
//             ),
//           ),
//         ));
//   }
// }
