import 'dart:io';

import 'package:stream_chatter/data/image_picker_repository.dart';
import 'package:stream_chatter/domain/usecases/create_group_usecase.dart';
import 'package:stream_chatter/ui/home/chat/selection/friends_selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class GroupSelectionState {
  const GroupSelectionState(
    this.file, {
    this.channel,
    this.isLoading = false,
  });
  final File file;
  final Channel channel;
  final bool isLoading;
}

class GroupSelectionCubit extends Cubit<GroupSelectionState> {
  GroupSelectionCubit(
    this.members,
    this._createGroupUseCase,
    this._imagePickerRepository,
  ) : super(GroupSelectionState(null));

  final nameTextController = TextEditingController();
  final List<ChatUserState> members;
  final CreateGroupUseCase _createGroupUseCase;
  final ImagePickerRepository _imagePickerRepository;

  void createGroup() async {
    emit(GroupSelectionState(state.file, isLoading: true));
    final channel = await _createGroupUseCase.createGroup(CreateGroupInput(
      imageFile: state.file,
      members: members.map((e) => e.chatUser.id).toList(),
      name: nameTextController.text,
    ));
    emit(GroupSelectionState(state.file, channel: channel, isLoading: false));
  }

  void pickImage() async {
    final image = await _imagePickerRepository.pickImage();
    emit(GroupSelectionState(image));
  }
}
