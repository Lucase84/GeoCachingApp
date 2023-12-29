import 'package:flutter/material.dart';
import 'package:flutter_application_1/Routes/authentification.dart';
import 'package:flutter_application_1/Routes/user_picture.dart';
import 'package:flutter_application_1/State_manager/user_manager.dart';
import 'package:flutter_application_1/Views/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(UserModel userModel) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final http.Response res =
          await UserPictureManager().updateUserPicture(pickedFile);

      if (res.statusCode == 200) {
        // Update the picture display with the new one using the captured context
        userModel.setPhotoURL(res.body);

        debugPrint('New profile picture set');
      }
    }
  }

  // Function to log out the user
  Future<void> _logOut() async {
    context.read<UserModel>().setUser(null);
    await AuthenticationService().signOut();
    if (context.mounted) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<LoginPage>(
          builder: (BuildContext context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the UserModel from the provider
    final UserModel userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Profile picture with rounded edges
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    userModel.photoURL ??
                        'https://imgs.search.brave.com/bQ087Mlmq2LyP0irV62DIA1Na1jFJUHBUuvu7Av8s5Q/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvQUIy/Njk2My9waG90by9s/aW9uLmpwZz9zPTYx/Mng2MTImdz0wJms9/MjAmYz1RUzd5bEFX/dktFMHB5a2F6UUFf/WDFQT05qOUpubkxG/eGhnUlN5WFRVUkVR/PQ',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Button to change profile picture
            ElevatedButton(
              onPressed: () async {
                await _pickImage(userModel);
              },
              child: const Text('Change Profile Picture'),
            ),

            // Spacer for some vertical space between the picture and text
            const SizedBox(height: 16),

            // Display user name
            Text(
              userModel.user?.displayName ?? 'No name available',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            // Spacer for some vertical space between the name and email
            const SizedBox(height: 8),

            // Display user email
            Text(
              userModel.user?.email ?? 'No email available',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            // Spacer for some vertical space between the email and the button
            const SizedBox(height: 16),

            // Button to log out
            ElevatedButton(
              onPressed: () async {
                await _logOut();
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
