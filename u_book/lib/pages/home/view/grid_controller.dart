import 'package:flutter/material.dart';
import 'package:u_book/widgets/widgets.dart';

class GirdStateController<T> {
  GirdStateController({required this.items});
  List<T> items;
  GlobalKey<SliverAnimatedGridState> girdKey = GlobalKey();

  SliverAnimatedGridState? get animatedGridState => girdKey.currentState;

  void insertItem(int index) {
    assert(animatedGridState != null, "girdKey chưa được set");
    assert(index >= 0 && index <= items.length, "err");
    // animatedGridState?.insertItem(index, duration: const Duration(milliseconds: 200));
    animatedGridState?.insertAllItems(0, 3);
  }

  // void addAll(List<T> values) {

  //   animatedGridState?.insertAllItems(index, length)
  //   items.addAll(values);
  // }

  Future<T> deleteItemByIndex(int index) async {
    final T removedItem = items.removeAt(index);
    //   animatedGridState?.removeItem(index, (context, animation) {
    //     print(animation.value);
    //     return FadeTransition(
    //         opacity: CurvedAnimation(parent: animation, curve: Curves.linear),
    //         child: Container(
    //           height: 50,
    //           width: 90,
    //           color: Colors.red,
    //         ));
    //   });
//  Transform.translate(
//           offset: Offset(0, (1 - (animation.value as double)) * 60),
//           child: child,
//         )
    // animatedGridState?.removeItem(index, (context, animation) {
    //   print(animation.value);
    //   return AnimatedBuilder(
    //     animation: animation,
    //     builder: (context, child) => SlideTransition(
    //         // alignment: Alignment.centerLeft,
    //         // offset: Offset(0, animation.value),
    //         position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
    //             .animate(
    //                 CurvedAnimation(parent: animation, curve: Curves.linear)),
    //         child: Container(
    //           height: 150,
    //           width: 140,
    //           color: Colors.red,
    //           child: Text(animation.value.toString()),
    //         )),
    //   );
    // }, duration: const Duration(milliseconds: 150));

    animatedGridState?.removeItem(index, (context, animation) {
      print(animation.value);
      return SlideTransition(
          // alignment: Alignment.centerLeft,
          // offset: Offset(0, animation.value),
          // offset: Offset((1 - animation.value) * 10, 0),
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.elasticInOut)).animate(animation),
          child: Container(
            height: 140,
            width: 140,
            color: Colors.teal,
            child: Text(animation.value.toString()),
          ));
    }, duration: const Duration(milliseconds: 300));
    return removedItem;
  }

  void deleteAll() {
    animatedGridState?.removeAllItems((context, animation) => Container());
  }
}
