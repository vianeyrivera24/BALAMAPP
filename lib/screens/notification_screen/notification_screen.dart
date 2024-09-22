import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:itizapp/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  static String routeName = 'NotificationScreen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Query dbRef = FirebaseDatabase.instance.ref().child('notificaciones');

  Widget listItem({required Map notificaciones}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // cambios en la posición de la sombra
          ),
        ],
        border: Border.all(
          color: kPrimaryColor, // puedes ajustar el color del borde aquí
          width: 1.0,
        ),
      ),
      child: ListTile(
        title: Text(
          notificaciones['titulo'],
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 16.0,
                color: kTextBlackColor,
                fontWeight: FontWeight.w800,
              ),
        ),
        subtitle: Text(
          notificaciones['mensaje'],
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 15.0,
                color: kContainerColor,
              ),
        ),
        leading: notificaciones['imageUrl'] != null
            ? Image.network(notificaciones['imageUrl'])
            : Icon(
                Icons.notifications,
                color: Theme.of(context).primaryColor,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.only(right: kDefaultPadding / 2),
            ),
          ),
        ],
      ),
      body: Container(
        color: kOtherColor,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(kDefaultPadding * 2),
                  bottomLeft: Radius.circular(kDefaultPadding * 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    maxRadius: 50.0,
                    minRadius: 50.0,
                    backgroundColor: kSecondaryColor,
                    backgroundImage: AssetImage('assets/images/3177440.png'),
                  ),
                  kWidthSizedBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '-',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Carrera - | Semestre -',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 14.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            sizedBox,
            Expanded(
              child: FirebaseAnimatedList(
                query: dbRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map notificaciones = snapshot.value as Map;
                  notificaciones['key'] = snapshot.key;

                  return listItem(notificaciones: notificaciones);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
