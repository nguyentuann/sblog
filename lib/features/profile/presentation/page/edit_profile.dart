import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/blog/presentation/bloc/post_create/post_create_bloc.dart';
import 'package:sblog/features/profile/domain/usecases/profile_usecase.dart';
import 'package:sblog/features/profile/presentation/bloc/profile_update_bloc.dart';
import 'package:sblog/features/profile/presentation/widget/profile_chooseavt.dart';
import 'package:sblog/features/profile/presentation/widget/profile_textfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.user});
  final User user;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  var avtUrl = '';

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _firstnameController.text = widget.user.firstname;
    _lastnameController.text = widget.user.lastname;
    _bioController.text = widget.user.bio ?? '';
    avtUrl = widget.user.avatar ?? '';
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Gửi sự kiện upload ảnh
      BlocProvider.of<PostCreateBloc>(context).add(UploadImage(image: _image!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileUpdateBloc(
        ProfileUsecase(),
      ),
      child: BlocListener<PostCreateBloc, PostCreateState>(
        listener: (context, state) {
          if (state is UploadImageSuccess) {
            setState(() {
              avtUrl = state.url;
              log('URL ảnh tải lên: $avtUrl');
              // Nếu muốn cập nhật avatar hiển thị ngay khi upload xong:
              if (_image != null) {
                // Có thể reset _image nếu muốn
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tải ảnh thành công!')),
            );
          } else if (state is UploadImageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
          builder: (context, state) {
            if (state is ProfileUpdateSuccess) {
              Navigator.pop(context, true);
            } else if (state is ProfileUpdateLoading) {
              // return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Failed to update")),
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text('Infomation Edit'),
                actions: [
                  IconButton(
                    onPressed: () {
                      context.read<ProfileUpdateBloc>().add(
                            ProfileUpdate(
                              User(
                                id: widget.user.id,
                                email: widget.user.email,
                                follower: widget.user.follower,
                                following: widget.user.following,
                                firstname: _firstnameController.text,
                                lastname: _lastnameController.text,
                                bio: _bioController.text,
                                avatar: avtUrl,
                                isFollowing: false,
                              ),
                            ),
                          );
                    },
                    icon: const Icon(Icons.check, size: 30),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : (widget.user.avatar != null
                                          ? NetworkImage(widget.user.avatar!)
                                          : const AssetImage(
                                              'assets/images/avt.jpg'))
                                      as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => ImagePickerOptions(
                                      onImagePicked:
                                          _pickImage, // ✅ Truyền đúng hàm xử lý ảnh
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Họ
                      CustomTextField(
                          controller: _firstnameController,
                          labelText: 'Firstname'),
                      const SizedBox(height: 20),

                      // Tên
                      CustomTextField(
                        controller: _lastnameController,
                        labelText: 'Lastname',
                      ),
                      const SizedBox(height: 20),

                      // Tiểu sử (bio)
                      CustomTextField(
                        controller: _bioController,
                        labelText: 'Bio',
                        keyboardType: TextInputType.multiline,
                        allowEmpty: true,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
