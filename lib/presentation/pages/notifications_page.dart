import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'type': 'demande_rdv',
      'clientName': 'Sophie Martin',
      'service': 'Coiffure',
      'date': '2024-01-15',
      'time': '14:00',
      'message':
          'Bonjour, je souhaiterais prendre rendez-vous pour une coupe de cheveux.',
      'isRead': false,
      'timeAgo': 'Il y a 5 min',
    },
    {
      'id': '2',
      'type': 'demande_rdv',
      'clientName': 'Marie Dubois',
      'service': 'Manucure',
      'date': '2024-01-16',
      'time': '10:30',
      'message': 'Salut ! J\'aimerais une manucure pour le weekend.',
      'isRead': true,
      'timeAgo': 'Il y a 1h',
    },
    {
      'id': '3',
      'type': 'avis',
      'clientName': 'Julie Bernard',
      'service': 'Maquillage',
      'message': 'Très satisfaite de votre travail ! Merci beaucoup.',
      'rating': 5,
      'isRead': false,
      'timeAgo': 'Il y a 2h',
    },
    {
      'id': '4',
      'type': 'demande_rdv',
      'clientName': 'Claire Moreau',
      'service': 'Massage',
      'date': '2024-01-17',
      'time': '16:00',
      'message':
          'Bonjour, avez-vous des créneaux disponibles pour un massage ?',
      'isRead': false,
      'timeAgo': 'Il y a 3h',
    },
    {
      'id': '5',
      'type': 'avis',
      'clientName': 'Anne Petit',
      'service': 'Coiffure',
      'message': 'Super coiffure, je recommande !',
      'rating': 4,
      'isRead': true,
      'timeAgo': 'Il y a 1 jour',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () {
              // Marquer toutes les notifications comme lues
              setState(() {
                for (var notification in notifications) {
                  notification['isRead'] = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Toutes les notifications marquées comme lues'),
                ),
              );
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucune notification',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(notification);
              },
            ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isUnread = !notification['isRead'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isUnread ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isUnread
            ? BorderSide(color: Colors.blue.withOpacity(0.3), width: 1)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getNotificationColor(notification['type']).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getNotificationIcon(notification['type']),
            color: _getNotificationColor(notification['type']),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification['clientName'],
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  notification['timeAgo'],
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (notification['type'] == 'demande_rdv') ...[
                  TextButton(
                    onPressed: () => _acceptRequest(notification),
                    child: const Text(
                      'Accepter',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _declineRequest(notification),
                    child: const Text(
                      'Refuser',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        onTap: () {
          _markAsRead(notification);
          _showNotificationDetails(notification);
        },
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'demande_rdv':
        return Colors.blue;
      case 'avis':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'demande_rdv':
        return Icons.calendar_today;
      case 'avis':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  void _markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['isRead'] = true;
    });
  }

  void _acceptRequest(Map<String, dynamic> notification) {
    setState(() {
      notification['isRead'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Demande de ${notification['clientName']} acceptée'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _declineRequest(Map<String, dynamic> notification) {
    setState(() {
      notification['isRead'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Demande de ${notification['clientName']} refusée'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['clientName']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service: ${notification['service']}'),
            if (notification['date'] != null)
              Text('Date: ${notification['date']}'),
            if (notification['time'] != null)
              Text('Heure: ${notification['time']}'),
            const SizedBox(height: 8),
            Text(notification['message']),
            if (notification['rating'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Note: '),
                  ...List.generate(
                      5,
                      (index) => Icon(
                            index < notification['rating']
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.orange,
                            size: 20,
                          )),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
