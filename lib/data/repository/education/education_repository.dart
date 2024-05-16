import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:history_app/data/repository/authentication/authentication_repository.dart';
import 'package:history_app/features/education/models/book_model.dart';
import 'package:history_app/features/education/models/chapter_model.dart';
import 'package:history_app/features/education/models/history_model.dart';
import 'package:history_app/features/education/models/option_model.dart';
import 'package:history_app/features/education/models/question_model.dart';
import 'package:history_app/features/education/models/quiz_model.dart';
import 'package:history_app/features/education/models/subject_model.dart';
import 'package:history_app/utils/exceptions/firebase_exceptions.dart';
import 'package:history_app/utils/exceptions/format_exceptions.dart';
import 'package:history_app/utils/exceptions/platform_exceptions.dart';
import 'package:history_app/utils/local_storage/storage_utility.dart';

class EducationRepository extends GetxController {
  static EducationRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final localStorage = TLocalStorage();

  Future<List<SubjectModel>> getSubjects() async {
    try {
      var subjects = <SubjectModel>[];
      final lastUpdatedLocal = localStorage.readData('subjects_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', 'subjects');

      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final QuerySnapshot<Map<String, dynamic>> res = await _db.collection("subjects").get();
        subjects = res.docs.map((doc) => SubjectModel.fromSnapshot(doc)).toList();

        await localStorage.saveData('subjects', subjects.map((subject) => subject.toJson()).toList());
        await localStorage.saveData('subjects_lastUpdated', lastUpdatedFirebase.toIso8601String());
      } else {
        final List<dynamic> storedSubjects = localStorage.readData('subjects');
        subjects = storedSubjects.map((json) => SubjectModel.fromJson(json)).toList();
      }

      return subjects;
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<BookModel>> getBooks(String subjectId) async {
    try {
      var books = <BookModel>[];
      final key = '${subjectId}_books';
      final lastUpdatedLocal = localStorage.readData('${key}_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', key);

      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final QuerySnapshot<Map<String, dynamic>> res = await _db.collection("subjects").doc(subjectId).collection("books").get();
        books = res.docs.map((doc) => BookModel.fromSnapshot(doc)).toList();

        await localStorage.saveData(key, books.map((book) => book.toJson()).toList());
        await localStorage.saveData('${key}_lastUpdated', lastUpdatedFirebase.toIso8601String());
      } else {
        final List<dynamic> storedBooks = localStorage.readData(key);
        books = storedBooks.map((json) => BookModel.fromJson(json)).toList();
      }

      return books;
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ChapterModel>> getChapters(String subjectId, String bookId) async {
    try {
      var chapters = <ChapterModel>[];
      final key = '${subjectId}_${bookId}_chapters';
      final lastUpdatedLocal = localStorage.readData('${key}_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', key);

      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final QuerySnapshot<Map<String, dynamic>> res = await _db.collection("subjects").doc(subjectId).collection("books").doc(bookId).collection("chapters").get();
        chapters = res.docs.map((doc) => ChapterModel.fromSnapshot(doc)).toList();

        await localStorage.saveData(key, chapters.map((chapter) => chapter.toJson()).toList());
        await localStorage.saveData('${key}_lastUpdated', lastUpdatedFirebase.toIso8601String());
      } else {
        final List<dynamic> storedChapters = localStorage.readData(key);
        chapters = storedChapters.map((json) => ChapterModel.fromJson(json)).toList();
      }

      return chapters;
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw 'Бірдеңе дұрыс болмады, қайталап көріңіз';
    }
  }

  Future<List<QuizModel>> getQuizzes(String subjectId, String bookId, String chapterId) async {
    try {
      var quizzes = <QuizModel>[];
      final key = '_${subjectId}_${bookId}_${chapterId}_quizzes';
      final lastUpdatedLocal = localStorage.readData('${key}_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', key);

      DateTime? lastUpdatedLocalDateTime;
      if (lastUpdatedLocal != null) {
        lastUpdatedLocalDateTime = DateTime.tryParse(lastUpdatedLocal);
      }

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final QuerySnapshot<Map<String, dynamic>> res =
            await _db.collection("subjects").doc(subjectId).collection("books").doc(bookId).collection("chapters").doc(chapterId).collection("quizzes").get();
        quizzes = res.docs.map((doc) => QuizModel.fromSnapshot(doc)).toList();

        await localStorage.saveData(key, quizzes.map((quiz) => quiz.toJson()).toList());
        await localStorage.saveData('${key}_lastUpdated', lastUpdatedFirebase.toIso8601String());
      } else {
        final List<dynamic> storedQuizzes = localStorage.readData(key);
        quizzes = storedQuizzes.map((json) => QuizModel.fromJson(json)).toList();
      }

      return quizzes;
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw 'Бірдеңе дұрыс болмады, қайталап көріңіз';
    }
  }

  Future<List<QuestionModel>> getQuestions(String subjectId, String bookId, String chapterId, String quizId) async {
    try {
      var questions = <QuestionModel>[];
      final key = '${subjectId}_${bookId}_${chapterId}_${quizId}_questions';
      final lastUpdatedLocal = localStorage.readData('${key}_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', key);

      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final QuerySnapshot<Map<String, dynamic>> res = await _db
            .collection("subjects")
            .doc(subjectId)
            .collection("books")
            .doc(bookId)
            .collection("chapters")
            .doc(chapterId)
            .collection("quizzes")
            .doc(quizId)
            .collection("questions")
            .get();
        questions = res.docs.map((doc) => QuestionModel.fromSnapshot(doc)).toList();

        // Fetch options for each question and add them to the corresponding QuestionModel
        for (var i = 0; i < questions.length; i++) {
          String questionId = questions[i].questionId; // Assuming QuestionModel has a questionId field
          var options = await getOptions(subjectId, bookId, chapterId, quizId, questionId);
          questions[i] = questions[i].copyWith(
            question: processText(questions[i].question),
            options: options,
          );
        }

        await localStorage.saveData(key, questions.map((question) => question.toJson()).toList());
        await localStorage.saveData('${key}_lastUpdated', lastUpdatedFirebase.toIso8601String());
      } else {
        final List<dynamic> storedQuestions = localStorage.readData(key);
        questions = storedQuestions.map((json) => QuestionModel.fromJson(json)).toList();
      }

      return questions;
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }

  String processText(String text) {
    return text.replaceAll('\\n', '\n');
  }

  Future<List<OptionModel>> getOptions(String subjectId, String bookId, String chapterId, String quizId, String questionId) async {
    try {
      var options = <OptionModel>[];
      final QuerySnapshot<Map<String, dynamic>> res = await _db
          .collection("subjects")
          .doc(subjectId)
          .collection("books")
          .doc(bookId)
          .collection("chapters")
          .doc(chapterId)
          .collection("quizzes")
          .doc(quizId)
          .collection("questions")
          .doc(questionId)
          .collection("options")
          .get();
      options = res.docs.map((doc) => OptionModel.fromSnapshot(doc)).toList();
      return options;
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<DateTime> _getLastUpdatedTimestampFromFirebase(String collection, String? key) async {
    try {
      var doc = await _db.collection(collection).doc(key).get();
      var lastUpdatedTimestamp = doc.data()?['lastUpdated'] as Timestamp?;
      return lastUpdatedTimestamp?.toDate() ?? DateTime.now();
    } catch (e) {
      // Handle errors or return a default value
      return DateTime.now();
    }
  }

  Future<void> saveHistory(HistoryModel history) async {
    try {
      var userId = AuthenticationRepository.instance.authUser?.uid;
      var historyRef = FirebaseFirestore.instance.collection("Histories").doc(userId);

      // Fetch the document for the user
      var doc = await historyRef.get();

      if (doc.exists) {
        // User history exists, append new history and update lastUpdated
        await historyRef.update({
          'lastUpdated': DateTime.now(),
          'histories': FieldValue.arrayUnion([history.toJson()]),
        });
      } else {
        // Create new document with history and lastUpdated
        await historyRef.set({
          'lastUpdated': DateTime.now(),
          'histories': [history.toJson()],
        });
      }
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw 'Бірдеңе дұрыс болмады, қайталап көріңіз';
    }
  }

  Future<List<HistoryModel>> getHistories() async {
    try {
      var histories = <HistoryModel>[];
      var userId = AuthenticationRepository.instance.authUser?.uid;
      final lastUpdatedLocal = localStorage.readData('histories_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Histories', userId);

      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        var historyDoc = await _db.collection("Histories").doc(userId).get();
        if (historyDoc.exists) {
          var data = historyDoc.data() ?? {};
          var historyList = data['histories'] as List<dynamic>? ?? [];
          histories = historyList.map((json) => HistoryModel.fromJson(json as Map<String, dynamic>)).toList();

          await localStorage.saveData('histories', historyList);
          await localStorage.saveData('histories_lastUpdated', lastUpdatedFirebase.toIso8601String());
        }
      } else {
        final List<dynamic> storedHistories = localStorage.readData('histories');
        histories = storedHistories.map((json) => HistoryModel.fromJson(json as Map<String, dynamic>)).toList();
      }

      return histories;
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logDeletion(String collectionPath, String itemId) async {
    try {
      await _db.collection('DeletionLog').add({
        'collectionPath': collectionPath,
        // e.g., 'subjects/{subjectId}/books/{bookId}'
        'itemId': itemId,
        'deletedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle errors
      throw "Error logging deletion: $e";
    }
  }

  Future<void> syncDeletions() async {
    try {
      var deletionLogSnapshot = await _db.collection('DeletionLog').get();

      for (var logEntry in deletionLogSnapshot.docs) {
        var data = logEntry.data();
        var collectionPath = data['collectionPath'];
        var itemId = data['itemId'];

        // Remove the item from local storage based on collectionPath and itemId
        await localStorage.removeFromLocalStorage(collectionPath, itemId);

        // Optionally, delete the log entry if the deletion has been synced
        await _db.collection('DeletionLog').doc(logEntry.id).delete();
      }
    } catch (e) {
      // Handle errors
      throw "Жоюларды синхрондауда қате пайда болды:$e";
    }
  }

  @override
  void onInit() async {
/*    final quiz1 = QuizModel(quizId: '1quiz', chapterId: '', bookId: '', subjectId: '', price: 1000, discount: 0,
        title: 'I-нұсқа', isBuy: false, questions: variant1);
    final quiz2 = QuizModel(quizId: '2quiz', chapterId: '', bookId: '', subjectId: '', price: 1000, discount: 0,
        title: 'II-нұсқа', isBuy: false, questions: variant2);*/

    print('start to set');
    await uploadDummyData([/*quiz1, quiz2*/]);
    print('end to set');
    super.onInit();
  }

  Future<void> uploadDummyData(List<QuizModel> quizzes) async {
    try {
      var batch = _db.batch();
      const chapterName = '11chapter';
      const bookName = '7classroom';
      const subjectName = 'historyOfKazakhstan';
      for (var quiz in quizzes) {
        batch.set(_db.collection('subjects').doc(subjectName).collection('books').doc(bookName).collection('chapters').doc(chapterName).collection('quizzes').doc(quiz.quizId),
            quiz.toFirebase());
        for (var question in quiz.questions) {
          batch.set(
              _db
                  .collection('subjects')
                  .doc(subjectName)
                  .collection('books')
                  .doc(bookName)
                  .collection('chapters')
                  .doc(chapterName)
                  .collection('quizzes')
                  .doc(quiz.quizId)
                  .collection('questions')
                  .doc(question.questionId),
              question.toFirebase());
          for (var option in question.options) {
            batch.set(
                _db
                    .collection('subjects')
                    .doc(subjectName)
                    .collection('books')
                    .doc(bookName)
                    .collection('chapters')
                    .doc(chapterName)
                    .collection('quizzes')
                    .doc(quiz.quizId)
                    .collection('questions')
                    .doc(question.questionId)
                    .collection('options')
                    .doc(option.optionId),
                option.toFirebase());
          }
        }
        batch.set(_db.collection('Metadata').doc('${subjectName}_${bookName}_${chapterName}_${quiz.quizId}_questions'), {'lastUpdated': Timestamp.fromDate(DateTime.now())});
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }
  final variant3 = <QuestionModel>[
    QuestionModel(questionId: '01', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '02', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '03', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '04', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '05', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '06', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '07', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '08', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '09', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '10', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '11', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '12', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '13', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '14', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '15', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '16', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '17', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '18', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '19', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '20', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '21', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '22', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '23', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '24', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '25', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '26', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '27', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '28', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '29', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '30', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '31', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '32', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '33', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '34', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '35', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '36', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '37', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '38', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '39', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),]),
    QuestionModel(questionId: '40', question: '', options: [
      OptionModel(optionId: 'A',      answer: '', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '', isCorrect: false),
      OptionModel(optionId: 'F',      answer: '', isCorrect: false),
      OptionModel(optionId: 'G',      answer: '', isCorrect: false),
      OptionModel(optionId: 'H',      answer: '', isCorrect: false),]),
  ];
  final variant1 = <QuestionModel>[
    QuestionModel(questionId: '01', question: '1861 жылы орыс-қазақ мектептебі ашылған қала:', options: [
      OptionModel(optionId: 'A',      answer: 'Ырғыз', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Торғай', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Омбы', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Троицк', isCorrect: true),
      OptionModel(optionId: 'E',      answer: 'Семей', isCorrect: false),]),
    QuestionModel(questionId: '02', question: '1858 жылы Баянауылсыртқыокругінің Қызылтау тауының етегінде орналасқан«Ашамайтас» елді мекеніндедүниеге келген:', options: [
      OptionModel(optionId: 'A',      answer: 'Ыбырай Алтынсарин', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Абай Құнанбайұлы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Құрбанғали Халид', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Шәкәрім Құдайбердіұлы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Мәшһүр Жүсіп Көпейұлы', isCorrect: true),]),
    QuestionModel(questionId: '03', question: '«Бұл ғаламда ол білмейтін дүние жоқ!» деп кім айтты:', options: [
      OptionModel(optionId: 'A',      answer: 'Мәшһүр Жүсіп Көпейұлы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Абайбайдың ұлы Мағауия', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Абайдың ұлы Әбдірахман', isCorrect: true),
      OptionModel(optionId: 'D',      answer: 'Шәкәрім Құдайбердіұлы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Абай Құнанбаев ', isCorrect: false),]),
    QuestionModel(questionId: '04', question: 'Ресейаумағында жарық көрген басылымдар мен кітап-газеттерді алдырыптұрған:', options: [
      OptionModel(optionId: 'A',      answer: 'Мәшһүр Жүсіп Көпейұлы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Абай Құнанбайұлы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Құрбанғали Халид', isCorrect: true),
      OptionModel(optionId: 'D',      answer: 'Шәкәрім Құдайбердіұлы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ыбырай Алтынсарин', isCorrect: false),]),
    QuestionModel(questionId: '05', question: '«Түрік, қырғыз, қазақ һәм хандар шежіресі»кітабының авторы:', options: [
      OptionModel(optionId: 'A',      answer: 'Мәшһүр Жүсіп Көпейұлы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Абай Құнанбайұлы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Құрбанғали Халид', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Шәкәрім Құдайбердіұлы', isCorrect: true),
      OptionModel(optionId: 'E',      answer: 'Ыбырай Алтынсарин', isCorrect: false),]),
    QuestionModel(questionId: '06', question: 'Абайдың саяси көзқарасына ықпал еткен зиялылардың бірі:', options: [
      OptionModel(optionId: 'A',      answer: 'Я.Каменский', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Н.Долгополов', isCorrect: true),
      OptionModel(optionId: 'C',      answer: 'Л.Толстой', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'И.А.Крылов', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'А.С.Пушкин', isCorrect: false),]),
    QuestionModel(questionId: '07', question: 'Қазанда жарық көрген «Жарида», Тауарих хамса» атты тарихи этнографиялық зерттеулердің авторы:', options: [
      OptionModel(optionId: 'A',      answer: 'Мәшһүр Жүсіп Көпейұлы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Абай Құнанбайұлы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Құрбанғали Халид', isCorrect: true),
      OptionModel(optionId: 'D',      answer: 'Шәкәрім Құдайбердіұлы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ыбырай Алтынсарин', isCorrect: false),]),
    QuestionModel(questionId: '08', question: 'Ы. Алтынсариннің педагогикалық көзқарасының қалыптасуына ықпал еткен орыс педагогы:', options: [
      OptionModel(optionId: 'A',      answer: 'К.Ушинский', isCorrect: true),
      OptionModel(optionId: 'B',      answer: 'С.Гросс', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Л.Толстой', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'И.А.Крылов', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'А.С.Пушкин', isCorrect: false),]),
    QuestionModel(questionId: '09', question: '«Сарыарқаның кімдікі екендігі» кітабының авторы:', options: [
      OptionModel(optionId: 'A',      answer: 'Мәшһүр Жүсіп Көпейұлы', isCorrect: true),
      OptionModel(optionId: 'B',      answer: 'Абай Құнанбайұлы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Құрбанғали Халид', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Шәкәрім Құдайбердіұлы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ыбырай Алтынсарин', isCorrect: false),]),
    QuestionModel(questionId: '10', question: 'Абылай ханға «Ұлы Даланың айбынды билеушісі» ретінде баға береді:', options: [
      OptionModel(optionId: 'A',      answer: 'Мәшһүр Жүсіп Көпейұлы', isCorrect: true),
      OptionModel(optionId: 'B',      answer: 'Абай Құнанбайұлы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Құрбанғали Халид', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Шәкәрім Құдайбердіұлы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ыбырай Алтынсарин', isCorrect: false),]),
    QuestionModel(questionId: '11', question: '«Қазақ даласына саяхат»  атты  суретті альбомның авторы:', options: [
      OptionModel(optionId: 'A',      answer: 'В.В.Верещагин', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'А.Э.Брэм', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Б.Залесский', isCorrect: true),
      OptionModel(optionId: 'D',      answer: 'Т.У.Аткинсон', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Т.Г.Щевченко', isCorrect: false),]),
    QuestionModel(questionId: '12', question: '1835 жылы осы ханның тікелей  нұсқауы бойынша мешіт ашылды:', options: [
      OptionModel(optionId: 'A',      answer: 'Нұралы хан', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Кенесары хан', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Жәңгір хан', isCorrect: true),
      OptionModel(optionId: 'D',      answer: 'Бөкей хан', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Айшуақ хан', isCorrect: false),]),
    QuestionModel(questionId: '13', question: '«Шоқан Уәлиханов шығыстану ғылымында аққан жұлдыздай жарқ етті де жоқ болды», - деп жазған:', options: [
      OptionModel(optionId: 'A',      answer: 'А.Седельников', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'А.Е.Алекторов', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Н.И.Веселовский', isCorrect: true),
      OptionModel(optionId: 'D',      answer: 'И.Гаспринский', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ф.Собысевич', isCorrect: false),]),
    QuestionModel(questionId: '14', question: 'Шәкәрім «тарихи хикая» деп атаған еңбегі:', options: [
      OptionModel(optionId: 'A',      answer: '«Мұсылмандық шарты»', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '«Түрік, қырғыз, қазақ һәм хандар шежіресі»', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '«Жарида»', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '«Қазақ даласына саяхат»  ', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '«Қалқаман-Мамыр»', isCorrect: true),]),
    QuestionModel(questionId: '15', question: 'Ыбырай Орынборда оқып жүрген кезiнде жақын таныс болған шығыстанушығалым:', options: [
      OptionModel(optionId: 'A',      answer: 'А.Седельников', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'А.Е.Алекторов', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Н.И.Веселовский', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'И.Гаспринский', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'В.В.Григорьев', isCorrect: true),]),
    QuestionModel(questionId: '16', question: 'Ыбырай Орынбор шегара комиссиясы жанындағы мектептi алтын медальмен бiтiрдi:', options: [
      OptionModel(optionId: 'A',      answer: '1860 жылы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '1864 жылы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '1879 жылы', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '1857 жылы', isCorrect: true),
      OptionModel(optionId: 'E',      answer: '1880 жылы', isCorrect: false),]),
    QuestionModel(questionId: '17', question: '1869жылы Ы. АлтынсаринТорғай уездiк басқармасынаорналасқанқызметі:', options: [
      OptionModel(optionId: 'A',      answer: 'кеңсе қызметкерi', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'уезд бастығының аға көмекшiсi', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'уақытшауездiксудья', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Торғай облысы мектептерiнiң инспекторы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'iс жүргiзушi', isCorrect: true),]),
    QuestionModel(questionId: '18', question: 'Абай өлеңдерiнiңең алғашқы жинағыбасылып шықты:', options: [
      OptionModel(optionId: 'A',      answer: '1905 жылы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '1907 жылы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '1879 жылы', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '1897 жылы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '1909 жылы', isCorrect: true),]),
    QuestionModel(questionId: '19', question: 'Мәшһүр Жүсіп Көпейұлынхалық аңыздары мен дастан, поэмаларын жатқа айтқаны үшін «Мәшһүр» атандырған:', options: [
      OptionModel(optionId: 'A',      answer: 'Ж.Досмұхамедов', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'А.Құнанбаев', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Ә.Бөкейханов', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Ы.Алтынсарин', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'М.Шорманов', isCorrect: true),]),
    QuestionModel(questionId: '20', question: 'Қазақ балаларына арналған интернаты бар мектеп салтанатты түрде ашылды:', options: [
      OptionModel(optionId: 'A',      answer: '1860 жылы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '1864 жылы', isCorrect: true),
      OptionModel(optionId: 'C',      answer: '1879 жылы', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '1857 жылы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '1880 жылы', isCorrect: false),]),
    QuestionModel(questionId: '21', question: 'Шығыстың бес елі, соның қатарында қазақхалқының тарихын толық қамтуға тырысқан еңбек:', options: [
      OptionModel(optionId: 'A',      answer: '«Мұсылмандық шарты» ', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '«Түрік, қырғыз, қазақ һәм хандар шежіресі»', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '«Жарида»', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '«Қазақ даласына саяхат»  ', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '«Тауарих хамса»', isCorrect: true),]),
    QuestionModel(questionId: '22', question: 'Шоқан Уәлихановқа жергiлiктi мәрмәр тастанқашапқұлпытас жасаған:', options: [
      OptionModel(optionId: 'A',      answer: 'А.Седельников', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Г.Н. Потанин', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Н.И.Веселовский', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Л.Ластовский', isCorrect: true),
      OptionModel(optionId: 'E',      answer: 'Ф.М. Достоевский', isCorrect: false),]),
    QuestionModel(questionId: '23', question: 'Шоқан кадет корпусында бiрге оқып,достасып кеткен белгiлi ғалым, географжәне Азияны зерттеушi:', options: [
      OptionModel(optionId: 'A',      answer: 'А.Седельников', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Г.Н. Потанин', isCorrect: true),
      OptionModel(optionId: 'C',      answer: 'Н.И.Веселовский', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Л.Ластовский', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ф.М. Достоевский', isCorrect: false),]),
    QuestionModel(questionId: '24', question: '1789 жылыАзия мектебi ашылды:', options: [
      OptionModel(optionId: 'A',      answer: 'Омбыда', isCorrect: true),
      OptionModel(optionId: 'B',      answer: 'Орынборда', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Екатеринбургте', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Қазанда', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ташкентте', isCorrect: false),]),
    QuestionModel(questionId: '25', question: 'Орынбор Неплюев кадет корпусы ашылды:', options: [
      OptionModel(optionId: 'A',      answer: '1813 жылы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '1820 жылы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '1825 жылы', isCorrect: true),
      OptionModel(optionId: 'D',      answer: '1841 жылы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '1861 жылы', isCorrect: false),]),
    QuestionModel(questionId: '26', question: 'Сәйкестендіру:\n1. Абай өз атынан жариялаған  шығармасы \n2. XIX ғ. екінші жартысындағы қазақтың болмысын зерттеген шығарма \n3. Орыс тілінен қазақ тіліне аударылған шығарма \nа-Қанжар б-Жаз с-Қарасөз', options: [
      OptionModel(optionId: 'A',      answer: '1-а 2-б 3-с', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '1-б 2-а 3-с', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '1-а 2-с 3-б', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '1-б 2-с 3-а', isCorrect: true),]),
    QuestionModel(questionId: '27', question: 'Дұрыс емес дәйекті табыңыз:\nА) 1909 жылы ақын Көкбайдың арқасында Қазан қаласында Абай өлеңдері басылып шықты\nВ) Абай Құнанбайұлы “Ескендір” өлеңін  жазды \nС) Қазақ халқының тарихын,әдет-ғұрпын, ауыз әдебиетін зерттешілердің бірі Ш.Құдайбердіұлы \nД) Шәкәрім “Мұсылмандық шарты” атты еңбегін жазды', options: [
      OptionModel(optionId: 'A',      answer: 'а,с', isCorrect: true),
      OptionModel(optionId: 'B',      answer: 'с,д', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'а,в', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'в,с', isCorrect: false),]),
    QuestionModel(questionId: '28', question: 'Мәшһүр Жүсіп туралы дұрыс дәйекті анықтаңыз:\n1. Бұхардағы Көкілташ медресесіне оқыған\n2. Қызылбөрі деген жерде дүниеге келген\n3. "Ер Олжабай батыр" эпосын жазған\n4. Доспамбет жыраудың жерлерген жерін тапқан', options: [
      OptionModel(optionId: 'A',      answer: '1,3', isCorrect: true),
      OptionModel(optionId: 'B',      answer: '2,4', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '2,3', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '3,4', isCorrect: false),]),
    QuestionModel(questionId: '29', question: 'Сәйкестендіру:\n1.Ы. Алтынсариннің педагогикалык көзқарасының қалыптасуына  ықпалы тиген орыс және чех педагогтері  \n2. Абайдың саяси көзқарасының қалыптасуына ықпал етткен жазушылар\n3.Абай Құнанбайұлы орыс тілінен аударған шығармалар авторлары \n4. ⁠Ы. Аштынсарин танысқан орыстың көрнекті демократтары\nА- Н.Г. Чернышевский және Н.А Добролюбов\nВ-Ушинский және Коменский\nС-Лермонтов және Пушкин\nД-Госс және Долгополов', options: [
      OptionModel(optionId: 'A',      answer: '1-А 2-С 3-Д 4-В', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '1-В 2-Д 3-С 4-А', isCorrect: true),
      OptionModel(optionId: 'C',      answer: '1-С 2-Д 3-В 4-А', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '1-В 2-С 3-Д 4-А', isCorrect: false),]),
    QuestionModel(questionId: '30', question: 'Хронологиялық ретпен орналастыр:\n1) М.Жүсіп Қамар хазіреттің көмегімен  “Ер Олжабай Батыр”эпосын жазды\n2) Абайдың ұлы Мағауия дүниеден өтті\n3) Құрбанғали Халидтің «Тауарих Хамса  атты еңбегі шықты\n4) Абай өз көзімен көрген жұт болды', options: [
      OptionModel(optionId: 'A',      answer: '3,4,2,1', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '3,1,2,4', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '1,3,2,4', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '1,4,2,3', isCorrect: true),]),

  ];
  final variant2 = <QuestionModel>[
    QuestionModel(questionId: '01', question: 'Жастайынан Ы.Алтынсарин кімнің қолында тәрбиеленді:', options: [
      OptionModel(optionId: 'A',      answer: 'Ауыл молдасының', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Ғалым Григорьевтің', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'А. Ильминскийдің', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Атасы Балғожаның', isCorrect: true),
      OptionModel(optionId: 'E',      answer: 'Үлкен әкесі Алтынсарының', isCorrect: false),]),
    QuestionModel(questionId: '02', question: 'Ы. Алтынсариннің педагогикалық көзқарасының қалыптасуына ықпал еткен чех ойшылы:', options: [
      OptionModel(optionId: 'A',      answer: 'Я.Каменский', isCorrect: true),
      OptionModel(optionId: 'B',      answer: 'С.Гросс', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Л.Толстой', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'И.А.Крылов', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'А.С.Пушкин', isCorrect: false),]),
    QuestionModel(questionId: '03', question: 'Ы. Алтынсариннің негізгі оқу құралы:', options: [
      OptionModel(optionId: 'A',      answer: '«Бастауыш (қазақ) хрестоматиясы»', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '«Есек пен бұлбұл»', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '«Кел, балалар оқылық»', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '«Қырғыздарды орыс тіліне үйретуге негізгі басшылық»', isCorrect: true),
      OptionModel(optionId: 'E',      answer: '«Қыпшақ Сейітқұл»', isCorrect: false),]),
    QuestionModel(questionId: '04', question: 'Семейдегі Абай білім алған оқу орны:', options: [
      OptionModel(optionId: 'A',      answer: '4 сыныпты гимназия', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '«Ахмет Ризаның » медресесі', isCorrect: true),
      OptionModel(optionId: 'C',      answer: 'Қазақ мұғалімдер мектебі', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Семей облыстық статистикалық комитеті', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Семей училищесі', isCorrect: false),]),
    QuestionModel(questionId: '05', question: 'Ы. Алтынсариннің патша үкіметінің жергілікті халыққа қысым жасайтын жүргенсіз саясатын айыптайтын мақалалары жарияланған газет:', options: [
      OptionModel(optionId: 'A',      answer: 'Оренбургские ведомости', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Уральский вестник', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Сибирский инвалид', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Оренбургский листок', isCorrect: true),
      OptionModel(optionId: 'E',      answer: 'Русский  инвалид', isCorrect: false),]),
    QuestionModel(questionId: '06', question: 'Медреселерде міндетті түрде орыс тілі үйрету енгізілді:', options: [
      OptionModel(optionId: 'A',      answer: '1900 жылы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '1825 жылы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '1892 жылы', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '1813 жылы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '1870 жылы', isCorrect: true),]),
    QuestionModel(questionId: '07', question: 'Ықыластың күйлері:', options: [
      OptionModel(optionId: 'A',      answer: 'Жігер, Бұлбұл, Қоңыр, Тартыс, Желдірме', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Сараыарқа, Ақсақ киік, Түрмеден қашқан, Балбырауын', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Саржайлау, Былқылдақ, Бес төре, Қосбасар', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Бес төре, Жезкиік, Кертолғау, Аққу, Ерден', isCorrect: true),
      OptionModel(optionId: 'E',      answer: 'Ноғайлы босқыны, Окоп, Жұртта қалған', isCorrect: false),]),
    QuestionModel(questionId: '08', question: 'Т.Шевченконың суретіне жатпайды:', options: [
      OptionModel(optionId: 'A',      answer: '«Боранда»', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '«Келі түйген келіншек»', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '«Салт атты қырғыз»', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '«Лепсі алқабы»', isCorrect: true),
      OptionModel(optionId: 'E',      answer: '«Қазақ қызы Катя»', isCorrect: false),]),
    QuestionModel(questionId: '09', question: 'Каир университетінде жоғары білім алған: ', options: [
      OptionModel(optionId: 'A',      answer: 'Ж.Досмұхамедов', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'С.Асфендияров', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Ә.Бөкейханов', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'М.Ғабдолғазиев', isCorrect: true),
      OptionModel(optionId: 'E',      answer: 'М.Шоқай', isCorrect: false),]),
    QuestionModel(questionId: '10', question: '«Олар қандай мақтауға болса да лайықты, білімді тез меңгеріп алады, оқуға қабілетті келеді» деп жазған орыс зерттеушісі:', options: [
      OptionModel(optionId: 'A',      answer: 'Сухотин', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'А.Е.Алекторов', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Ильминский', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'И.Гаспринский', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ф.Собысевич', isCorrect: true),]),
    QuestionModel(questionId: '11', question: '«Дала көшпенділері малшылар»  атты  еңбектің авторы:', options: [
      OptionModel(optionId: 'A',      answer: 'В.В.Верещагин', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'А.Э.Брэм', isCorrect: true),
      OptionModel(optionId: 'C',      answer: 'Б.Залесский', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Т.У.Аткинсон', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Т.Г.Щевченко', isCorrect: false),]),
    QuestionModel(questionId: '12', question: '«Азияда көшіп-қонып жүретін  түркілердің ішінде қырғыз-қазақтар басқаларға қарағанда  мәдениетті халық. Сондықтан олардың болашағы зор. Бұл халық жаңалықты бойына тез сіңіреді екен» деп жазған:', options: [
      OptionModel(optionId: 'A',      answer: 'А.Седельников', isCorrect: true),
      OptionModel(optionId: 'B',      answer: 'А.Е.Алекторов', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Ильминский', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'И.Гаспринский', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ф.Собысевич', isCorrect: false),]),
    QuestionModel(questionId: '13', question: 'Алғашқы зайырлы мектеп осы ханның бастамасымен ашылды:', options: [
      OptionModel(optionId: 'A',      answer: 'Нұралы хан', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Кенесары хан', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Жәңгір хан', isCorrect: true),
      OptionModel(optionId: 'D',      answer: 'Бөкей хан', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Айшуақ хан', isCorrect: false),]),
    QuestionModel(questionId: '14', question: 'Бұхарадағы Көкілташ медресесінде оқыған:', options: [
      OptionModel(optionId: 'A',      answer: 'Мәшһүр Жүсіп Көпейұлы', isCorrect: true),
      OptionModel(optionId: 'B',      answer: 'Абай Құнанбайұлы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Құрбанғали Халид', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Шәкәрім Құдайбердіұлы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ыбырай Алтынсарин', isCorrect: false),]),
    QuestionModel(questionId: '15', question: '«Бұл ғаламда ол білмейтін дүние жоқ!» деп кім туралы айтылған:', options: [
      OptionModel(optionId: 'A',      answer: 'Мәшһүр Жүсіп Көпейұлы', isCorrect: true),
      OptionModel(optionId: 'B',      answer: 'Абайбайдың ұлы Мағауия', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Абайдың ұлы Әбдірахман', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Шәкәрім Құдайбердіұлы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Абай Құнанбаев ', isCorrect: false),]),
    QuestionModel(questionId: '16', question: 'Ы. Алтынсарин Торғай облысы мектептерiнiң инспекторыболып тағайындалды:', options: [
      OptionModel(optionId: 'A',      answer: '1860 жылы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '1864 жылы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '1879 жылы', isCorrect: true),
      OptionModel(optionId: 'D',      answer: '1857 жылы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '1880 жылы', isCorrect: false),]),
    QuestionModel(questionId: '17', question: 'Ы. Алтынсарин патша үкiметiнiң жергiлiктi халыққақысым жасайтын жүгенсiз саясатын айыптаған мақаласы «Оренбургский листок» газетінде жарияланды:', options: [
      OptionModel(optionId: 'A',      answer: '1860 жылы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '1864 жылы', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '1879 жылы', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '1857 жылы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '1880 жылы', isCorrect: true),]),
    QuestionModel(questionId: '18', question: 'Мектептi бiтiрiп шыққан  Ы. Алтынсарин үш жылдай атасының қол астында қандай қызмет атқарды:', options: [
      OptionModel(optionId: 'A',      answer: 'кеңсе қызметкерi', isCorrect: true),
      OptionModel(optionId: 'B',      answer: 'уезд бастығының аға көмекшiсi', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'уақытша уездiк судья', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Торғай облысы мектептерiнiң инспекторы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'iс жүргiзушi', isCorrect: false),]),
    QuestionModel(questionId: '19', question: 'Ы. Алтынсариннің орыс-қазақ мектептерiнiң оқушыларына арнап жазған оқу құралы:', options: [
      OptionModel(optionId: 'A',      answer: '«Қырғыз (қазақ) хрестоматиясы»', isCorrect: true),
      OptionModel(optionId: 'B',      answer: '«Есек пен бұлбұл»', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '«Кел, балалар оқылық»', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '«Бұратаналарды орыс тіліне үйретуге негізгі басшылық»', isCorrect: false),
      OptionModel(optionId: 'E',      answer: '«Қыпшақ Сейітқұл»', isCorrect: false),]),
    QuestionModel(questionId: '20', question: 'Абай өлеңдерiнiң ең алғашқы жинағы басылып шықты:', options: [
      OptionModel(optionId: 'A',      answer: 'Омбыда', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Орынборда', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Екатеринбургте', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Қазанда', isCorrect: true),
      OptionModel(optionId: 'E',      answer: 'Ташкентте', isCorrect: false),]),
    QuestionModel(questionId: '21', question: 'Құнанбайұлының өлеңдерiнжинауға және бастырыпшығаруға көп күш-жiгер жұмсап, игi ықпал еткенақын:', options: [
      OptionModel(optionId: 'A',      answer: 'Абайдыңұлы Турағұл', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Абайбайдың ұлы Мағауия', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Абайдың ұлы Әбдірахман', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Шәкәрім Құдайбердіұлы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Көкбай Жаңатайұлы', isCorrect: true),]),
    QuestionModel(questionId: '22', question: 'Құрбанғали Халидтіңеңбектері қазақ халқының тарихының қай кезеңін зерттеудеқұнды дерек саналады:', options: [
      OptionModel(optionId: 'A',      answer: 'ХVІ–ХҮІІ ғасырлардағы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'ХVІІІ–ХІХ ғасырлард', isCorrect: true),
      OptionModel(optionId: 'C',      answer: 'ХV–ХҮІ ғасырлардағы', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'ХІV–ХҮ ғасырлардағы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'ХІІІ–ХІҮ ғасырлардағы', isCorrect: false),]),
    QuestionModel(questionId: '23', question: 'Шәкәрім еңбектері басылып шықты:', options: [
      OptionModel(optionId: 'A',      answer: 'Омбыда', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Орынборда', isCorrect: true),
      OptionModel(optionId: 'C',      answer: 'Еnкатеринбургте', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Қазанда', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ташкентте', isCorrect: false),]),
    QuestionModel(questionId: '24', question: '1880 жылғы алапат ауыр жұтты өз көзiменкөрдi:', options: [
      OptionModel(optionId: 'A',      answer: 'Мәшһүр Жүсіп Көпейұлы', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'Абайбайдың ұлы Мағауия', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Абайдың ұлы Әбдірахман', isCorrect: false),
      OptionModel(optionId: 'D',      answer: 'Шәкәрім Құдайбердіұлы', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Абай Құнанбаев', isCorrect: true),]),
    QuestionModel(questionId: '25', question: '«Орынбор ведомствосы қырғыздарының құдатүсу мен үйлену тойы кезiндегi әдет-ғұрыптарының очеркi» атты еңбектің авторы:', options: [
      OptionModel(optionId: 'A',      answer: 'Ш.Уәлиханов', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'А.Е.Алекторов', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'Ы.Алтынсарин', isCorrect: true),
      OptionModel(optionId: 'D',      answer: 'И.Гаспринский', isCorrect: false),
      OptionModel(optionId: 'E',      answer: 'Ф.Собысевич', isCorrect: false),]),
    QuestionModel(questionId: '26', question: 'Сәйкестендіріңіз:\n1.Қазақ поэзиясының философиялық саласын дамытты\n2.Оңтүстік және Батыс Қазақстан аумағын түгелдей аралап шықты \n3."қазақ" атауына дәйекті түрде түсіндірме берді \nа- Мәшһүр Жүсіп \nб- Шәкәрім Құдайбердіұлы \nс- Құрбанғали Халид ', options: [
      OptionModel(optionId: 'A',      answer: '1-а 2-б 3-с', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '1-б 2-а 3-с', isCorrect: true),
      OptionModel(optionId: 'C',      answer: '1-а 2-с 3-б', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '1-б 2-с 3-а', isCorrect: false),]),
    QuestionModel(questionId: '27', question: 'Дұрыс дәйекті табыңыз:\n1. Ы.Алтынсарин өз замандастары арасында аудармашы ретінде танылған \n2. 1863 жылы қазақ балаларына интернат ашылды\n3.Алтынсариннің педагогикалық қалыптасуына Ушинскийдің еңбектері ықпал етті \n4.1860 жылы Торғай қаласында қазақ балалары үшін бастауыш мектеп ашылды', options: [
      OptionModel(optionId: 'A',      answer: '1,2', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '2,3', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '1,4', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '3,4', isCorrect: true),]),
    QuestionModel(questionId: '28', question: 'Сәйкестендіру:\n1.Ы.Алтынсарин Уақытша ережеде белгіленген сайлау тәртібін бұзды деп айыпталды\n2.Ы. Алтынсарин Торғай облысы мектептерінің инспекторы болып тағайындалды.\n3.Ы. Алтынсарин Торғай уездік бастығының аға көмекшісі және уақытша уездік судья міндеттерін қатар атқарған уақыт\n4.Қазақбалаларынаарналған интернаты бар мектепашылды\nА-1864\nВ-1879\nС-1868\nД-1869', options: [
      OptionModel(optionId: 'A',      answer: '1-В 2-С 3-Д 4-А', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '1-С 2-В 3-А 4-Д', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '1-Д 2-С 3-В 4-А', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '1-С 2-В 3-Д 4-А', isCorrect: true),]),
    QuestionModel(questionId: '29', question: 'Дұрыс емес дәйекті табыңыз\nА) Ы.Алтынсарин 1869 жылғы “Уақытша ережеде” белгіленген сайлау тәртібін бұзды деп айыпталды\nВ) Ы.Алтынсарин  қазақ балалар әдебиетінің негізін қалаушы \nС)1879 жылы Ы.Алтынсарин Орынбор облысы мектептерінің инспекторы болып тағайындалды\nД) Ы.Алтынсариннің педагогикалық көзқарасының қалыптасуына Я.Каменскийдің еңбектерімен таныс болуы оң әсері тиді', options: [
      OptionModel(optionId: 'A',      answer: 'а,д', isCorrect: false),
      OptionModel(optionId: 'B',      answer: 'с,д', isCorrect: false),
      OptionModel(optionId: 'C',      answer: 'с,а', isCorrect: true),
      OptionModel(optionId: 'D',      answer: 'а,в', isCorrect: false),]),
    QuestionModel(questionId: '30', question: 'Хронологиялық ретпен орналастырыңыз:\n1) Абай өлеңдерінің ең алғашқы жинағы басылып шықты\n2) Ы.Алтынсарин Торғай облысы мектептерінің инспекторы болып сайланды\n3) Құрбанғали Халидтің «Жарида» кітабы шықты\n4) Мәшһүр Жүсіп Қазан қаласында үш кітабы жарық көрді', options: [
      OptionModel(optionId: 'A',      answer: '4,2,1,3', isCorrect: false),
      OptionModel(optionId: 'B',      answer: '2,4,1,3', isCorrect: false),
      OptionModel(optionId: 'C',      answer: '4,2,3,1', isCorrect: false),
      OptionModel(optionId: 'D',      answer: '2,3,4,1', isCorrect: true),]),

  ];
}

