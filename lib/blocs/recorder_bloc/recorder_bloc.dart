import 'package:path_provider/path_provider.dart';
import 'package:practica_2_kevin_gonzalez/blocs/recorder_bloc/audd_repository.dart';
import 'package:practica_2_kevin_gonzalez/models/song_track_model.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'recorder_event.dart';
part 'recorder_state.dart';

class RecorderBloc extends Bloc<RecorderEvent, RecorderState> {
  final Record _record = Record();
  final AudDRepository _audDRepository;

  RecorderBloc({required AudDRepository audDRepository})
      : _audDRepository = audDRepository,
        super(RecorderInitialState()) {
    on<RecorderStartRecordingEvent>(_startRecording);
    on<RecorderAnalizeRecordingEvent>(_analyzeRecording);
  }

  FutureOr<void> _startRecording(
      RecorderStartRecordingEvent event, Emitter<RecorderState> emit) async {
    try {
      // Check microphone access and request permission
      await _checkMicrophonePermission();
      await _assertNotRecordingAlready();
      String recordingSavePath = await _getExternalDirPath();
      // Start recording
      await _initRecording('$recordingSavePath/myFile.wav');
      emit(RecorderRecordingState());
      // Wait for recording to finish with a 6s delay after being called
      String recordingPath = await _finishRecording(const Duration(seconds: 6));
      emit(RecorderRecordingSuccessState(pathToRecording: recordingPath));
    } on _StateException catch (errorState) {
      emit(errorState.nextState);
    }
  }

  FutureOr<void> _analyzeRecording(
      RecorderAnalizeRecordingEvent event, Emitter<RecorderState> emit) async {
    emit(RecorderAnalizingRecordingState());
    SongTrackModel? foundTrack =
        await _audDRepository.analyzeAudioFromPath(event.pathToRecording);
    if (foundTrack == null) {
      emit(RecorderAnalysisErrorState(error: 'error'));
      return;
    }
    emit(
      RecorderAnalysisSucessState(
        track: foundTrack,
      ),
    );
  }

  Future<void> _checkMicrophonePermission() async {
    if (await _record.hasPermission() == false) {
      throw _StateException(
        nextState: RecorderRecordingState(
          message: 'Solicitando acceso al microfono',
        ),
      );
    }
  }

  Future<void> _assertNotRecordingAlready() async {
    if (await _record.isRecording()) {
      throw _StateException(
        nextState: RecorderRecordingState(
          message: 'Grabación en curso...',
        ),
      );
    }
  }

  FutureOr<String> _getExternalDirPath() async {
    final appDir = await getExternalStorageDirectory();
    if (appDir == null) {
      throw _StateException(
        nextState: RecorderRecordingErrorState(
          error: 'No se pudo acceder al directorio',
        ),
      );
    }
    return appDir.path;
  }

  FutureOr<void> _initRecording(String fileName) async {
    await _record.start(
      path: fileName,
      encoder: AudioEncoder.aacHe,
    );
  }

  FutureOr<String> _finishRecording(Duration delay) async {
    await Future.delayed(delay);
    String? filePath = await _record.stop();
    if (filePath == null) {
      throw _StateException(
        nextState: RecorderRecordingErrorState(
          error: 'No se pudo almacenar la grabacion',
        ),
      );
    }
    return filePath;
  }
}

class _StateException implements Exception {
  final RecorderState nextState;
  _StateException({required this.nextState});
}
