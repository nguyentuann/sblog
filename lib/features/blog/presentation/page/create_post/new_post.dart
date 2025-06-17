import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_embeds.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sblog/configs/theme/color.dart';
import 'package:sblog/common/presentation/widget/common_button.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/presentation/bloc/category/categories_bloc.dart';
import 'package:sblog/features/blog/presentation/bloc/post_create/post_create_bloc.dart';
import 'package:sblog/features/profile/presentation/widget/profile_textfield.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key, this.post});
  final Post? post;

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subTitleController;
  late quill.QuillController _contentController;
  final ImagePicker _picker = ImagePicker();
  final FocusNode _focusNode = FocusNode();
  File? _image;
  String? _thumbnailUrl;
  int? _selectedCategoryId;
  bool _showFull = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _subTitleController =
        TextEditingController(text: widget.post?.subTitle ?? '');
    _selectedCategoryId = widget.post?.categoryId;
    _thumbnailUrl = widget.post?.featuredImage;

    if (widget.post != null) {
      _contentController = quill.QuillController(
        document: quill.Document.fromJson(widget.post!.content),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: false,
        editorFocusNode: _focusNode,
      );
    } else {
      _contentController = quill.QuillController.basic();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subTitleController.dispose();
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleToolbar() {
    if (!mounted) return;
    setState(() {
      _showFull = !_showFull;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null || !mounted) return;

    setState(() {
      _image = File(pickedFile.path);
      _thumbnailUrl = null;
    });
    context
        .read<PostCreateBloc>()
        .add(UploadImage(image: File(pickedFile.path)));
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null || !mounted) return;

    File imageFile = File(pickedFile.path);
    context.read<PostCreateBloc>().add(UploadImage(image: imageFile));
  }


  void _insertImageIntoEditor(String imageUrl) {
    if (!mounted) return;

    try {
      final index = _contentController.selection.baseOffset;
      final length = _contentController.selection.extentOffset - index;

      _contentController.replaceText(
        index,
        length,
        quill.BlockEmbed.image(imageUrl),
        null, // Đổi thành null thay vì TextSelection
      );

      // Update selection sau khi insert
      _contentController.updateSelection(
        TextSelection.collapsed(offset: index + 1),
        quill.ChangeSource.local,
      );

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      log('Error inserting image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi chèn ảnh: $e')),
        );
      }
    }
  }

  void _handleCreate(BuildContext context) {
    FocusScope.of(context).unfocus();
    final title = _titleController.text.trim();
    final subTitle = _subTitleController.text.trim();
    final contentText = _contentController.document.toPlainText().trim();
    final contentJson = _contentController.document.toDelta().toJson();
    final wrapped = jsonEncode({'ops': contentJson});

    if (_formKey.currentState?.validate() != true) return;

    if (contentText.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Content cannot be empty!')),
        );
      }
      return;
    }
    if (_selectedCategoryId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category!')),
        );
      }
      return;
    }
    if (_thumbnailUrl == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a thumbnail image!')),
        );
      }
      return;
    }
    if (widget.post != null) {
      context.read<PostCreateBloc>().add(
            EditPost(
              id: widget.post!.id,
              title: title,
              subTitle: subTitle,
              content: wrapped,
              categoryId: _selectedCategoryId!,
              featuredImage: _thumbnailUrl!,
            ),
          );
    } else {
      context.read<PostCreateBloc>().add(
            CreatePost(
              title: title,
              subTitle: subTitle,
              content: wrapped,
              featuredImage: _thumbnailUrl!,
              categoryId: _selectedCategoryId!,
            ),
          );
    }
  }

  Text _headingPost(String msg) => Text(
        msg,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCreateBloc, PostCreateState>(
      listenWhen: (previous, current) =>
          current is PostCreateSuccess ||
          current is PostCreateFailure ||
          current is UploadImageSuccess,
      listener: (context, state) {
        if (!mounted) return;
        if (state is PostCreateSuccess) {
          Future.delayed(
            const Duration(seconds: 3),
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bài viết đã được đăng!')),
              );
            },
          );
          Navigator.of(context).pop();
        } else if (state is UploadImageSuccess) {
          if (_image != null && _thumbnailUrl == null) {
            if (mounted) {
              setState(() {
                _thumbnailUrl = state.url;
                _image = null;
              });
            }
          } else {
            _insertImageIntoEditor(state.url);
          }
        } else if (state is PostCreateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is PostCreateInProcess) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Share your thoughts'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headingPost('Title'),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _titleController,
                      labelText: 'Enter your title here',
                    ),
                    const SizedBox(height: 10),
                    _headingPost('Sub Title'),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _subTitleController,
                      labelText: 'Enter your sub title here',
                    ),
                    const SizedBox(height: 10),
                    _headingPost('Category'),
                    const SizedBox(height: 10),
                    BlocProvider(
                      create: (context) =>
                          CategoriesBloc()..add(GetCategories()),
                      child: BlocBuilder<CategoriesBloc, CategoriesState>(
                        builder: (context, state) {
                          if (state is CategoriesLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is CategoriesLoaded) {
                            if (_selectedCategoryId == null &&
                                state.categories.isNotEmpty) {
                              _selectedCategoryId = state.categories.first.id;
                            }
                            return DropdownButtonFormField<int>(
                              isExpanded: false,
                              value: _selectedCategoryId,
                              items: state.categories
                                  .map(
                                    (cat) => DropdownMenuItem<int>(
                                      value: cat.id,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          cat.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          overflow: TextOverflow
                                              .ellipsis, // Xử lý text dài
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                if (mounted) {
                                  setState(() {
                                    _selectedCategoryId = val;
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) => val == null
                                  ? 'Please select a category'
                                  : null,
                            );
                          }
                          return const Text('Không thể tải danh mục');
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _headingPost('Thumbnail Image'),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: _thumbnailUrl != null
                              ? Image.network(
                                  _thumbnailUrl!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : _image != null
                                  ? Image.file(
                                      _image!,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/bg.jpg',
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera),
                              label: const Text(
                                "Take a picture",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library),
                              label: const Text(
                                "Choose a picture",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _headingPost('Content'),
                    const SizedBox(height: 10),
                    quill.QuillToolbar.simple(
                      configurations: quill.QuillSimpleToolbarConfigurations(
                        controller: _contentController,
                        multiRowsDisplay: _showFull,
                        customButtons: [
                          quill.QuillToolbarCustomButtonOptions(
                            icon: const Icon(Icons.image),
                            onPressed: () => _pickAndUploadImage(),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          label: Text(
                            _showFull ? 'Hide' : 'Show more',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          icon: Icon(
                            _showFull
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: GeneralColors.blColor,
                          ),
                          onPressed: _toggleToolbar,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 300,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: quill.QuillEditor.basic(
                        configurations: quill.QuillEditorConfigurations(
                          controller: _contentController,
                          autoFocus: false,

                          expands: false,
                          padding: const EdgeInsets.all(8),
                          scrollable: true,
                          placeholder: 'Nhập nội dung bài viết...',
                          // Thêm embedBuilders để hiển thị ảnh
                          embedBuilders: [
                            ...FlutterQuillEmbeds.editorBuilders(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CommonButton(
                          title: 'Create',
                          onPressed: () => _handleCreate(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
