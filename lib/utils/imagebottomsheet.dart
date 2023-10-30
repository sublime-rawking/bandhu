import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';

bottomSheet(
    {required bool selected,
    required BuildContext context,
    required Function cameraBtn,
    required Function galleryBtn,
    required Function deleteBtn}) {
  return showModalBottomSheet(
    context: context,
    builder: (_) => Material(
      child: Container(
        height: 180,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        child: Center(
          child: Column(children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const Spacer(),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  pickerBtn(
                      name: "Camera",
                      iconName: Icons.camera_alt,
                      onPressFunc: cameraBtn),
                  const Spacer(),
                  pickerBtn(
                      name: "Gallery",
                      iconName: Icons.photo_library_sharp,
                      onPressFunc: galleryBtn),
                  selected ? const Spacer() : const SizedBox.shrink(),
                  selected
                      ? pickerBtn(
                          name: "Delete",
                          iconName: Icons.delete_outline_sharp,
                          onPressFunc: deleteBtn)
                      : const SizedBox.shrink(),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
          ]),
        ),
      ),
    ),
  );
}

Widget pickerBtn(
        {required Function onPressFunc,
        required String name,
        required IconData iconName}) =>
    InkWell(
      onTap: () => onPressFunc(),
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                iconName,
                color: Colors.white,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(name),
          )
        ],
      ),
    );
