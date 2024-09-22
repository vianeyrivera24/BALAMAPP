import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:itizapp/domain/entities/push_message.dart';
import 'package:itizapp/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

// Handler para mensajes en segundo plano
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

// Bloc de notificaciones
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('notificaciones');

  NotificationsBloc() : super(const NotificationsState()) {
    // Manejadores de eventos
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);
    on<LoadNotifications>(_loadNotifications);

    // Verificar estado de las notificaciones
    _initialStatusCheck();

    // Listener para notificaciones en Foreground
    _onForegroundMessage();

    // Cargar notificaciones persistentes al iniciar
    _loadPersistentNotifications();
  }

  // Inicializar Firebase Cloud Messaging (FCM)
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Cambiar estado de notificaciones
  void _notificationStatusChanged(
      NotificationStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  // Manejar recepción de notificaciones
  void _onPushMessageReceived(
      NotificationReceived event, Emitter<NotificationsState> emit) async {
    emit(state.copyWith(
      notifications: [event.pushMessage, ...state.notifications],
    ));
    _getFCMToken();

    // Guardar notificación en Firebase
    await _saveNotificationToDatabase(event.pushMessage);
  }

  // Verificar el estado inicial de las notificaciones
  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  // Obtener el token de FCM
  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    print(token);
  }

  // Manejar mensajes remotos
  void _handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;
    final notification = PushMessage(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
    );

    add(NotificationReceived(notification));
  }

  // Escuchar mensajes en primer plano
  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }

  // Solicitar permiso para notificaciones
  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  // Leer notificaciones desde Firebase
  void fetchNotificaciones() {
    _dbRef = FirebaseDatabase.instance.ref().child('notificaciones');
    _dbRef.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          data.forEach((key, value) {
            print('Notificación: $value');
          });
        }
      } else {
        print('No se encontraron notificaciones.');
      }
    });
  }

  // Guardar notificación en la base de datos
  Future<void> _saveNotificationToDatabase(PushMessage notification) async {
    try {
      final newNotificationRef = _dbRef.push();
      await newNotificationRef.set({
        'titulo': notification.title,
        'mensaje': notification.body,
        'timestamp': notification.sentDate.millisecondsSinceEpoch,
        'imageUrl': notification.imageUrl,
        'data': notification.data,
      });
      print('Notificación guardada con éxito.');
    } catch (e) {
      print('Error al guardar la notificación en la base de datos: $e');
    }
  }

  // Cargar notificaciones persistentes desde Firebase
  void _loadPersistentNotifications() async {
    final notificacionesRef = _dbRef;
    notificacionesRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> notificationsMap =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        List<PushMessage> notificationsList =
            notificationsMap.entries.map((entry) {
          final notificationData = Map<String, dynamic>.from(entry.value);
          return PushMessage(
            messageId: entry.key,
            title: notificationData['titulo'] ?? '',
            body: notificationData['mensaje'] ?? '',
            sentDate: DateTime.fromMillisecondsSinceEpoch(
                notificationData['timestamp']),
            data: notificationData['data'] ?? {},
            imageUrl: notificationData['imageUrl'],
          );
        }).toList();

        add(LoadNotifications(notificationsList));
      } else {
        print('No se encontraron notificaciones persistentes.');
      }
    });
  }

  // Evento para cargar notificaciones persistentes
  void _loadNotifications(
      LoadNotifications event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(notifications: event.notifications));
  }
}
