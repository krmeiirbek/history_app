import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/models/book_model.dart';
import 'package:history_app/features/education/models/chapter_model.dart';
import 'package:history_app/features/education/models/option_model.dart';
import 'package:history_app/features/education/models/question_model.dart';
import 'package:history_app/features/education/models/quiz_model.dart';
import 'package:history_app/features/education/models/subject_model.dart';
import 'package:history_app/utils/exceptions/firebase_exceptions.dart';
import 'package:history_app/utils/exceptions/format_exceptions.dart';
import 'package:history_app/utils/exceptions/platform_exceptions.dart';
import 'package:history_app/utils/local_storage/storage_utility.dart';

class EducationRepository extends GetxController {
  EducationRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final localStorage = TLocalStorage();

  Future<List<SubjectModel>> getSubjects() async {
    try {
      var subjects = <SubjectModel>[];
      final lastUpdatedLocal = localStorage.readData('subjects_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('subjects');

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
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase(key);

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
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase(key);

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
      throw 'Something went wrong, Please try again';
    }
  }

  Future<List<QuizModel>> getQuizzes(String subjectId, String bookId, String chapterId) async {
    try {
      var quizzes = <QuizModel>[];
      final key = '_${subjectId}_${bookId}_${chapterId}_quizzes';
      final lastUpdatedLocal = localStorage.readData('${key}_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase(key);

      DateTime? lastUpdatedLocalDateTime;
      if (lastUpdatedLocal != null) {
        lastUpdatedLocalDateTime = DateTime.tryParse(lastUpdatedLocal);
      }

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final QuerySnapshot<Map<String, dynamic>> res = await _db.collection("subjects")
            .doc(subjectId)
            .collection("books")
            .doc(bookId)
            .collection("chapters")
            .doc(chapterId)
            .collection("quizzes")
            .get();
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
      throw 'Something went wrong, Please try again';
    }
  }

  Future<List<QuestionModel>> getQuestions(String subjectId, String bookId, String chapterId, String quizId) async {
    try {
      var questions = <QuestionModel>[];
      final key = '${subjectId}_${bookId}_${chapterId}_${quizId}_questions';
      final lastUpdatedLocal = localStorage.readData('${key}_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase(key);

      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final QuerySnapshot<Map<String, dynamic>> res = await _db.collection("subjects")
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
      final QuerySnapshot<Map<String, dynamic>> res = await _db.collection("subjects")
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

  Future<DateTime> _getLastUpdatedTimestampFromFirebase(String key) async {
    try {
      var metadataDoc = await _db.collection('Metadata').doc(key).get();
      var lastUpdatedTimestamp = metadataDoc.data()?['lastUpdated'] as Timestamp?;
      return lastUpdatedTimestamp?.toDate() ?? DateTime.now();
    } catch (e) {
      // Handle errors or return a default value
      return DateTime.now();
    }
  }

  Future<void> logDeletion(String collectionPath, String itemId) async {
    try {
      await _db.collection('DeletionLog').add({
        'collectionPath': collectionPath, // e.g., 'subjects/{subjectId}/books/{bookId}'
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
      throw "Error syncing deletions: $e";
    }
  }

}