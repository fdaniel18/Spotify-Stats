import 'package:client/src/pages/admin/logic/logic.dart';
import 'package:flutter/material.dart';
import 'package:client/src/models/user.dart';

class UserTable extends StatefulWidget {
  final List<User> userData;

  const UserTable({super.key, required this.userData});

  @override
  _UserTableState createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  Future<void> _deleteUser(User user) async {
    bool isDeleted = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Confirm Deletion',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete ${user.firstName} ${user.lastName}?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.green)),
            ),
            ElevatedButton(
              onPressed: () async {
                bool success = await AdminLogic.deleteUser(user.id.toString());
                Navigator.pop(context, success);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (isDeleted) {
      setState(() {
        widget.userData.remove(user);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.firstName} ${user.lastName} has been deleted.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete ${user.firstName} ${user.lastName}.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _modifyUser(User user) {
    final TextEditingController firstNameController =
        TextEditingController(text: user.firstName);
    final TextEditingController lastNameController =
        TextEditingController(text: user.lastName);
    final TextEditingController emailController =
        TextEditingController(text: user.email);
    bool isAdmin = user.isAdmin;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, localSetState) {
            // Renaming setState to localSetState here
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Row(
                children: [
                  const Icon(Icons.edit, color: Colors.green),
                  const SizedBox(width: 10),
                  Text(
                    'Modify User: ${user.firstName} ${user.lastName}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              content: _buildUserForm(
                firstNameController,
                lastNameController,
                emailController,
                isAdmin,
                (value) => localSetState(() => isAdmin = value),
              ),
              actions: _buildDialogActions(
                'Save',
                onSave: () async {
                  bool success = await AdminLogic.updateUser(
                    user.id.toString(),
                    firstNameController.text,
                    lastNameController.text,
                    emailController.text,
                    isAdmin,
                  );
                  if (success) {
                    setState(() {
                      user.firstName = firstNameController.text;
                      user.lastName = lastNameController.text;
                      user.email = emailController.text;
                      user.isAdmin = isAdmin;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User updated successfully.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update user.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _insertUser() {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    bool isAdmin = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, localSetState) {
            // Use localSetState to avoid conflict
            return AlertDialog(
              backgroundColor: Colors.black,
              title: const Row(
                children: [
                  Icon(Icons.add, color: Colors.green),
                  SizedBox(width: 10),
                  Text('Add New User', style: TextStyle(color: Colors.white)),
                ],
              ),
              content: _buildUserForm(
                firstNameController,
                lastNameController,
                emailController,
                isAdmin,
                (value) => localSetState(() => isAdmin = value),
              ),
              actions: _buildDialogActions(
                'Add',
                onSave: () async {
                  bool success = await AdminLogic.createUser(
                    emailController.text,
                    firstNameController.text,
                    lastNameController.text,
                    isAdmin,
                  );
                  if (success) {
                    setState(() {
                      widget.userData.add(
                        User(
                          id: 0,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          isAdmin: isAdmin,
                        ),
                      );
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User added successfully.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Failed to add user. Make sure the email is unique and valid.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUserForm(
    TextEditingController firstNameController,
    TextEditingController lastNameController,
    TextEditingController emailController,
    bool isAdmin,
    Function(bool) setIsAdmin,
  ) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField('First Name', firstNameController),
          const SizedBox(height: 10),
          _buildTextField('Last Name', lastNameController),
          const SizedBox(height: 10),
          _buildTextField('Email', emailController,
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.admin_panel_settings,
                  color: isAdmin ? Colors.green : Colors.red),
              const SizedBox(width: 10),
              const Text('Admin', style: TextStyle(color: Colors.white)),
              Checkbox(
                value: isAdmin,
                onChanged: (bool? value) {
                  if (value != null) {
                    setIsAdmin(value);
                  }
                },
                activeColor: Colors.green,
                checkColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDialogActions(String buttonLabel,
      {required VoidCallback onSave}) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close', style: TextStyle(color: Colors.green)),
      ),
      ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: Text(buttonLabel, style: const TextStyle(color: Colors.white)),
      ),
    ];
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.green),
        enabledBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        focusedBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Scrollable user list area with a fixed height of 70% of the screen
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Scrollbar(
            trackVisibility: true,
            thickness: 12.0,
            radius: const Radius.circular(10),
            child: SingleChildScrollView(
              primary: true,
              child: ListView.builder(
                itemCount: widget.userData.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final user = widget.userData[index];
                  return Container(
                    color: Colors.black,
                    margin: const EdgeInsets.all(4),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      title: Row(
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: const TextStyle(color: Colors.green),
                          ),
                          if (user.isAdmin) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.admin_panel_settings,
                                color: Colors.blue),
                          ],
                        ],
                      ),
                      subtitle: Text(user.email,
                          style: const TextStyle(color: Colors.white)),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () => _modifyUser(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Padding for the button to insert a new user
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: _insertUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Insert New User',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
