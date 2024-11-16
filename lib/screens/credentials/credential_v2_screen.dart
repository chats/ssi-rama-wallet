import 'package:flutter/material.dart';
import 'package:ssi_rama_wallet/constants/constants.dart';

import '../../services/acapy/acapy_credential_service.dart';

class CredentialsV2Screen extends StatefulWidget {
  const CredentialsV2Screen({super.key});

  @override
  _CredentialsV2ScreenState createState() => _CredentialsV2ScreenState();
}

class _CredentialsV2ScreenState extends State<CredentialsV2Screen> {
  final AcaPyCredentialService acaPyService = AcaPyCredentialService(
    baseUrl: agentUrl,
    apiKey: agentKey,
  );
  
  List<Credential> credentials = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCredentials();
  }

  Future<void> fetchCredentials() async {
    setState(() => isLoading = true);
    try {
      final fetchedCredentials = await acaPyService.getW3cCredentials();
      setState(() {
        credentials = fetchedCredentials;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching credentials: $e')),
      );
    }
  }

  Future<bool?> _showDeleteDialog(Credential credential) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Credential'),
          content: Text('Are you sure you want to delete this credential?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          await acaPyService.deleteW3cCredential(credential.id);
          await fetchCredentials(); // Refresh the list after deletion
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Credential deleted successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting credential: $e')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('W3C Credentials'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchCredentials,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final credential = credentials[index];
                      return Dismissible(
                        key: Key(credential.id),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) => _showDeleteDialog(credential),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: CredentialCard(credential: credential),
                      );
                    },
                    childCount: credentials.length,
                  ),
                ),
              ],
            ),
    );
  }
}

class CredentialCard extends StatelessWidget {
  final Credential credential;

  const CredentialCard({Key? key, required this.credential}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Container(
        //color: Color(0xFF235255),
        color: theme.colorScheme.surfaceContainerHighest,
        child: ExpansionTile(
          title: Text(
            credential.credentialType ?? 'Unknown Type',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
          subtitle: Text(
            'Issued by: ${credential.issuer}\nDate: ${_formatDate(credential.issuanceDate)}',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          iconColor: theme.colorScheme.onSurface,
          collapsedIconColor: theme.colorScheme.onSurface,
          children: [
            Container(
              color: theme.colorScheme.surface,
              child: AttributesList(attributes: credential.attributes),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class AttributesList extends StatelessWidget {
  final Map<String, dynamic> attributes;

  const AttributesList({Key? key, required this.attributes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: attributes.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    '${_formatKey(entry.key)}:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '${entry.value}',
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match[1]}')
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}