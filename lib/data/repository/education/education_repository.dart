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
import 'package:history_app/features/ubt/models/ubt_option_model.dart';
import 'package:history_app/features/ubt/models/ubt_question_model.dart';
import 'package:history_app/features/ubt/models/ubt_quiz_model.dart';
import 'package:history_app/features/ubt/models/ubt_subject_model.dart';
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

  Future<List<UBTSubjectModel>> getUBTSubjects() async {
    try {
      var ubt_subjects = <UBTSubjectModel>[];
      final lastUpdatedLocal = localStorage.readData('ubt_subjects_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', 'ubt_subjects');
      print(lastUpdatedLocal);
      print(lastUpdatedFirebase);
      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;
      print(lastUpdatedLocalDateTime);
      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        print('read firebase');
        final QuerySnapshot<Map<String, dynamic>> res = await _db.collection("ubt_subjects").get();
        print(res.docs.length);
        ubt_subjects = res.docs.map((doc) => UBTSubjectModel.fromSnapshot(doc)).toList();

        await localStorage.saveData('ubt_subjects', ubt_subjects.map((subject) => subject.toJson()).toList());
        await localStorage.saveData('ubt_subjects_lastUpdated', lastUpdatedFirebase.toIso8601String());
      } else {
        print('read local');
        final List<dynamic> storedSubjects = localStorage.readData('ubt_subjects');
        ubt_subjects = storedSubjects.map((json) => UBTSubjectModel.fromJson(json)).toList();
      }

      return ubt_subjects;
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

  Future<List<UBTQuizModel>> getUBTQuizzes(String subjectId) async {
    try {
      print('subjectid: $subjectId');
      var quizzes = <UBTQuizModel>[];
      final key = '_${subjectId}_quizzes';
      final lastUpdatedLocal = localStorage.readData('${key}_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', key);

      DateTime? lastUpdatedLocalDateTime;
      if (lastUpdatedLocal != null) {
        lastUpdatedLocalDateTime = DateTime.tryParse(lastUpdatedLocal);
      }

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final QuerySnapshot<Map<String, dynamic>> res = await _db.collection("ubt_subjects").doc(subjectId).collection("quizzes").get();
        quizzes = res.docs.map((doc) => UBTQuizModel.fromSnapshot(doc)).toList();

        await localStorage.saveData(key, quizzes.map((quiz) => quiz.toJson()).toList());
        await localStorage.saveData('${key}_lastUpdated', lastUpdatedFirebase.toIso8601String());
      } else {
        final List<dynamic> storedQuizzes = localStorage.readData(key);
        quizzes = storedQuizzes.map((json) => UBTQuizModel.fromJson(json)).toList();
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
      print('key : $key');
      final lastUpdatedLocal = localStorage.readData('${key}_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', key);

      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        print('if');
        final QuerySnapshot<Map<String, dynamic>> res =
            await _db.collection("subjects").doc(subjectId).collection("books").doc(bookId).collection("chapters").doc(chapterId).collection("quizzes").doc(quizId).collection("questions").get();
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
        print('else');
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

  Future<List<UBTQuestionModel>> getUBTQuestions(String subjectId, String quizId) async {
    try {
      var questions = <UBTQuestionModel>[];
      final key = '${subjectId}_${quizId}_questions';
      final lastUpdatedLocal = localStorage.readData('${key}_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', key);

      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        print(subjectId);
        print(quizId);
        final QuerySnapshot<Map<String, dynamic>> res = await _db.collection("ubt_subjects").doc(subjectId).collection("quizzes").doc(quizId).collection("questions").get();
        questions = res.docs.map((doc) => UBTQuestionModel.fromSnapshot(doc)).toList();
        print(questions.length);

        // Fetch options for each question and add them to the corresponding QuestionModel
        for (var i = 0; i < questions.length; i++) {
          String questionId = questions[i].questionId; // Assuming QuestionModel has a questionId field
          var options = await getUBTOptions(subjectId, quizId, questionId);
          questions[i] = questions[i].copyWith(
            question: processText(questions[i].question),
            options: options,
          );
        }

        await localStorage.saveData(key, questions.map((question) => question.toJson()).toList());
        await localStorage.saveData('${key}_lastUpdated', lastUpdatedFirebase.toIso8601String());
      } else {
        final List<dynamic> storedQuestions = localStorage.readData(key);
        questions = storedQuestions.map((json) => UBTQuestionModel.fromJson(json)).toList();
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

  Future<List<UBTOptionModel>> getUBTOptions(String subjectId, String quizId, String questionId) async {
    try {
      var options = <UBTOptionModel>[];
      final QuerySnapshot<Map<String, dynamic>> res =
          await _db.collection("ubt_subjects").doc(subjectId).collection("quizzes").doc(quizId).collection("questions").doc(questionId).collection("options").get();
      options = res.docs.map((doc) => UBTOptionModel.fromSnapshot(doc)).toList();
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

  Future<void> uploadDummyData(List<QuizModel> quizzes) async {
    try {
      var batch = _db.batch();
      const chapterName = '05chapter';
      const bookName = '6classroom';
      const subjectName = 'worldHistory';
      for (var quiz in quizzes) {
        batch.set(_db.collection('subjects').doc(subjectName).collection('books').doc(bookName).collection('chapters').doc(chapterName).collection('quizzes').doc(quiz.quizId), quiz.toFirebase());
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
}
