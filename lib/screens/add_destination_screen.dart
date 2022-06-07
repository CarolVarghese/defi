import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:de_fi_sample1/resources/auth_methods.dart';
import 'package:de_fi_sample1/responsive/mobile_screen_layout.dart';
import 'package:de_fi_sample1/responsive/responsive_layout.dart';
import 'package:de_fi_sample1/responsive/web_screen_layout.dart';
import 'package:de_fi_sample1/screens/login_screen.dart';
import 'package:de_fi_sample1/utils/colors.dart';
import 'package:de_fi_sample1/utils/global_variable.dart';
import 'package:de_fi_sample1/utils/utils.dart';
import 'package:de_fi_sample1/widgets/text_field_input.dart';
import 'package:geolocator/geolocator.dart';

class AddDestinationScreen extends StatefulWidget {
  const AddDestinationScreen({Key? key}) : super(key: key);


  @override
  _AddDestinationScreenState createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
  final TextEditingController _destinationnameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _passwordController.dispose();
    _destinationnameController.dispose();
  }

  late String currentLocation = '' ;
  late Position position;

  void _getCurrentLocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          currentLocation ="Permission Denied";
        });
      }else{
        var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          currentLocation ="latitude: ${position.latitude}" + " , " + "Logitude: ${position.longitude}";
        });
      }
    }else{
      var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation ="latitude: ${position.latitude}" + " , " + "Logitude: ${position.longitude}";
      });
    }
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _descriptionController.text,
        password: _passwordController.text,
        username: _destinationnameController.text,
        bio: _bioController.text,
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Text('Add a Destination',
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                    fontSize: 40),
              ),
              const SizedBox(
                height: 64,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo),
                ),
              ),

              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Destination Name',
                textInputType: TextInputType.text,
                textEditingController: _destinationnameController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Discription',
                textInputType: TextInputType.emailAddress,
                textEditingController: _descriptionController,
              ),

              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    _getCurrentLocation();
                    },
                  child: const Text('Add location')),

        Container(
          decoration: BoxDecoration(
              color: Colors.grey
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
              children: <Widget>[
          Row(
          children: <Widget>[
              Icon(Icons.location_on),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Location',
                ),
                (currentLocation!=null)?Text(currentLocation):Container(),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ],
          ),
              ],
          ),
        ),
              InkWell(
                child: Container(
                  child: !_isLoading
                      ? const Text(
                    'Submit',
                  )
                      : const CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                ),
                onTap: signUpUser,
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
