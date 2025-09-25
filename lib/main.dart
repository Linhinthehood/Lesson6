import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson6',
      home: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class User {
  final String name;
  final String email;
  final int age;
  User({required this.name, required this.email, required this.age});
}

class _MainAppState extends State<MainApp> {
  List<User> users = [];

  void _addUser(User user) {
    setState(() {
      users.add(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: users.isEmpty
          ? Center(
              child: Text(
                'No users yet, please click on the button below to add Users',
              ),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(user.name[0])),
                  title: Text(user.name),
                  subtitle: Text('${user.email} | Age: ${user.age}'),
                  onTap: () async {
                    final editedUser = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUserScreen(user: user),
                      ),
                    );
                    if (editedUser != null && editedUser is User) {
                      setState(() {
                        users[index] = editedUser;
                      });
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newUser = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserScreen()),
          );
          if (newUser != null && newUser is User) {
            _addUser(newUser);
          }
        },
        tooltip: 'Add User',
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddUserScreen extends StatefulWidget {
  final User? user;
  const AddUserScreen({this.user});
  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _age;

  @override
  void initState() {
    super.initState();
    _name = widget.user?.name ?? '';
    _email = widget.user?.email ?? '';
    _age = widget.user?.age.toString() ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
                onSaved: (value) => _name = value ?? '',
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter email' : null,
                onSaved: (value) => _email = value ?? '',
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                initialValue: _age,
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter age';
                  if (int.tryParse(value) == null) return 'Enter valid number';
                  return null;
                },
                onSaved: (value) => _age = value ?? '',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final user = User(
                      name: _name,
                      email: _email,
                      age: int.parse(_age),
                    );
                    Navigator.pop(context, user);
                  }
                },
                child: Text(widget.user == null ? 'Add User' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
