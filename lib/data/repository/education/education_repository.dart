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
      var ubtSubjects = <UBTSubjectModel>[];
      final lastUpdatedLocal = localStorage.readData('ubt_subjects_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', 'ubt_subjects');
      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;
      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final QuerySnapshot<Map<String, dynamic>> res = await _db.collection("ubt_subjects").get();
        ubtSubjects = res.docs.map((doc) => UBTSubjectModel.fromSnapshot(doc)).toList();

        await localStorage.saveData('ubt_subjects', ubtSubjects.map((subject) => subject.toJson()).toList());
        await localStorage.saveData('ubt_subjects_lastUpdated', lastUpdatedFirebase.toIso8601String());
      } else {
        final List<dynamic> storedSubjects = localStorage.readData('ubt_subjects');
        ubtSubjects = storedSubjects.map((json) => UBTSubjectModel.fromJson(json)).toList();
      }

      return ubtSubjects;
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
      final lastUpdatedLocal = localStorage.readData('${key}_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', key);

      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final QuerySnapshot<Map<String, dynamic>> res =
            await _db.collection("subjects").doc(subjectId).collection("books").doc(bookId).collection("chapters").doc(chapterId).collection("quizzes").doc(quizId).collection("questions").get();
        questions = res.docs.map((doc) => QuestionModel.fromSnapshot(doc)).toList();

        for (var i = 0; i < questions.length; i++) {
          String questionId = questions[i].questionId;
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

  Future<List<UBTQuestionModel>> getUBTQuestions(String subjectId, String quizId) async {
    try {
      var questions = <UBTQuestionModel>[];
      final key = '${subjectId}_${quizId}_questions';
      final lastUpdatedLocal = localStorage.readData('${key}_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampFromFirebase('Metadata', key);

      DateTime? lastUpdatedLocalDateTime = lastUpdatedLocal != null ? DateTime.tryParse(lastUpdatedLocal) : null;

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final QuerySnapshot<Map<String, dynamic>> res = await _db.collection("ubt_subjects").doc(subjectId).collection("quizzes").doc(quizId).collection("questions").get();
        questions = res.docs.map((doc) => UBTQuestionModel.fromSnapshot(doc)).toList();

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
        'itemId': itemId,
        'deletedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
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

  @override
  void onInit() async {
    // final quiz1 = UBTQuizModel(quizId: '0001quiz', subjectId: '', title: '1-нұсқа', questions: variant1);
    // final quiz2 = UBTQuizModel(quizId: '0002quiz', subjectId: '', title: '2-нұсқа', questions: variant2);
    // final quiz3 = UBTQuizModel(quizId: '0003quiz', subjectId: '', title: '3-нұсқа', questions: variant3);
    // final quiz4 = UBTQuizModel(quizId: '0004quiz', subjectId: '', title: '4-нұсқа', questions: variant4);
    // final quiz5 = UBTQuizModel(quizId: '0005quiz', subjectId: '', title: '5-нұсқа', questions: variant5);
    // final quiz6 = UBTQuizModel(quizId: '0006quiz', subjectId: '', title: '6-нұсқа', questions: variant6);
    // final quiz7 = UBTQuizModel(quizId: '0007quiz', subjectId: '', title: '7-нұсқа', questions: variant7);

    print('start to set');
    // await uploadDummyDataForUBT([quiz1,quiz2,quiz3,quiz4,quiz5,quiz6,quiz7]);
    print('end to set');
    super.onInit();
  }

  Future<void> uploadDummyDataForUBT(List<UBTQuizModel> quizzes) async {
    try {
      var batch = _db.batch();
      const subjectName = 'worldHistory';
      for (var quiz in quizzes) {
        batch.set(_db.collection('ubt_subjects').doc(subjectName).collection('quizzes').doc(quiz.quizId), quiz.toFirebase());
        for (var question in quiz.questions) {
          batch.set(_db.collection('ubt_subjects').doc(subjectName).collection('quizzes').doc(quiz.quizId).collection('questions').doc(question.questionId), question.toFirebase());
          for (var option in question.options) {
            batch.set(
                _db.collection('ubt_subjects').doc(subjectName).collection('quizzes').doc(quiz.quizId).collection('questions').doc(question.questionId).collection('options').doc(option.optionId),
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



  final variant1 = <UBTQuestionModel>[
    UBTQuestionModel(questionId: '01', question: 'Шан(Инь) дәуіріндегі қоғамның сапалы жаңа дәуірге көшуде пайда болған жетістіктің бірі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'жазу', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'оқу', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'күнтізбе', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'егіншілік', isCorrect: false),]),
    UBTQuestionModel(questionId: '02', question: '330 жылы император Константин жариялаған империяның жаңа астанасы:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Македония', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Коринф', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Константинополь', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Милет', isCorrect: false),]),
    UBTQuestionModel(questionId: '03', question: '476 жылы құлаған империя:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Киев Русі', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Византия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Араб халифаты', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Батыс Рим', isCorrect: true),]),
    UBTQuestionModel(questionId: '04', question: '1500 жылы португалдық теңізші Педру Кабрал ашты:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Үндістанды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Мексиканы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Бразилияны', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Американы', isCorrect: false),]),
    UBTQuestionModel(questionId: '05', question: 'Герман империясы жарияланғаннан кейін, империяның Құрылтай жиналысы атауы:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Парламент', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Бас штаттар', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Рейхстаг', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Сейм', isCorrect: false),]),
    UBTQuestionModel(questionId: '06', question: '1815 жылы Вена конгресінің нәтижесінде Германияда орын алған саяси оқиғалардың бірі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Герман одағы таратылды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Герман одағы құрылды', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Отто фон Бисмарк билікке келді', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Неміс кедендік одағы құрылды', isCorrect: false),]),
    UBTQuestionModel(questionId: '07', question: 'XIX ғасырда мемлекеттердің экономикалық және саяси өмірінде қалыптасып, қоғамда жетекші орын ала бастаған тап:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'жұмысшы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'буржуазия', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'ағартушылар', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'шаруа', isCorrect: false),]),
    UBTQuestionModel(questionId: '08', question: 'Осман империясында 1826 жылы янычар әскерлерін тартқан тарихи тұлға:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'IIМахмұт', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Намык Кемал', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Мұстафа Решид', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Абдул-Меджид', isCorrect: false),]),
    UBTQuestionModel(questionId: '09', question: '1914 жылы 23 шілдеде Германияның айдап салуымен Австрия-Венгрия ультиматум жариялады:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ресейге', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Францияға', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Сербияға', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Италияға', isCorrect: false),]),
    UBTQuestionModel(questionId: '10', question: 'Әскери коммунизм саясатына тән белгіні анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Тауар, ақша қатынастарының дамуы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Жаппай еңбек міндеткерлігінің жойылуы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Өнеркәсіпті мемлекет меншігіне алу', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Жаппай еңбек мобилизациясының жойылуы', isCorrect: false),]),
    UBTQuestionModel(questionId: '11', question: '1930-жылдардағы КСРО-дағы тоталитарлық режімнің көрінісі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Әскери міндеткерлік', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Діни бостандық', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Жазықсыз қуғындау', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Көппартиялық жүйе', isCorrect: false),]),
    UBTQuestionModel(questionId: '12', question: 'XX ғасырдың басында Үндістанның барлық сыртқы саудасын бақылауда ұстаған банк:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Жапон', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Неміс', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Ағылшын', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Француз', isCorrect: false),]),
    UBTQuestionModel(questionId: '13', question: '1912 жылы Қытайда Біріккен одақ мүшелері құрған саяси партия:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Либералдық', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Лейбористік', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Гоминьдан', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Коммунистік', isCorrect: false),]),
    UBTQuestionModel(questionId: '14', question: '1922 жылы Вашингтон конференциясында Жапонияға қойылған талап:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Шаньдун түбегін Қытайға қайтару', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Антикоминтерндік пактідент шығу', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Кореяға тәуелсіздік беру', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Әуе қарулы күштерін шектеу', isCorrect: false),]),
    UBTQuestionModel(questionId: '15', question: 'Маршал Жуковтың басшылығымен фашистік Германияның Сөзсіз тізе бүгуі жөніндегі актіге қол қойылды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Лонданда', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Берлинде', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Мәскеуде', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Парижде', isCorrect: false),]),
    UBTQuestionModel(questionId: '16', question: 'XX ғасырдың 40 жылдарында Германияның Норвегия мен Данияға басып кіруінен кейін аяқталған соғыс:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Корей соғысы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Оғаш соғысы', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Қырғи қабақ соғысы', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Екінші дүниежүзілік соғысы', isCorrect: false),]),
    UBTQuestionModel(questionId: '17', question: 'Фултонда сөйлеген У.Черчилльдің сөзінің негізгі мақсаты:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Бүкіл әлемге Батыстың ықпалын орнату', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Еуропаны қайта қалпына келтіру идеясын ұсыну', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Екінші дүниежүзілік соғыс қорытындысын жариялау', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Коммунистік идеологияны насихаттау', isCorrect: false),]),
    UBTQuestionModel(questionId: '18', question: 'Халықаралық бейбітшілік пен қауіпсіздікті қамтамасыз ету міндетін атқаратын ұйым:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'ШЫҰ', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'БҰҰ', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'ДСҰ', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'ВШҰ', isCorrect: false),]),
    UBTQuestionModel(questionId: '19', question: '1951 жылы 18 сәуірде Парижде Еуропалық көмір және болат бірлестігін құру шартына қоль қойған мемлекеттер:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Англия, Италия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Люксембург, Бельгия', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'КСРО, Франция', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'ГДР, Нидерланды', isCorrect: false)]),
    UBTQuestionModel(questionId: '20', question: '1968 жылы Брежнев «Дунай»операциясы бойынша Варшава Шартына мүше елдердің әскерін кіргізуге келісім берді:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ауғанстанға', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Венгрияға', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Польшаға', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Чехословакияға', isCorrect: true),]),
    UBTQuestionModel(questionId: '21', question: '1919 жылы 18 қаңтарда Парижде бейбіт конференция ашылды. Оның жұмысына 35 мемлекеттің делегациясы қатысты.Париж конференциясының басты мақсаттары: Бірінші дүниежүзілік соғысты қорытындылау, Еуропа аумағын жеңген державалар пайдасына бөлу, соғыста жеңілген мемлекеттердің әскери күштерін шектеу. Сонымен қатар бұл мемлекеттер репарациялар төлеуге, яғни шығындарды ақтауға мәжбүр болды.....Әрбір жеңілген тараппен жеке-жеке: Герма- ниямен – Версаль (1919), Австриямен – Сен-Жермен (1919), Болгариямен – Нейи (1919), Венгриямен – Трианон (1920), Түркиямен – Севр (1920) бейбіт келісім- шарттары дайындалды.Германия басшылығы Австрия, Чехословакия, Польшаның тәуелсіздіктерін мойындады; Францияға Эльзас, Лотарингияны және Саар көмір шахталарын 15 жылға; Бельгияға, Польшаға, Данияға, Литваға жерлерді қайтарды.Версаль келісімшарты бойынша Германия толығымен Африка мен Азиядағы отарлық иеліктерінен айырылды.\nБірінші дүниежүзілік соғыстан кейін Еуропа аумағын жеңген державалар пайдасына бөлу мәселесін талқылаған конференция:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Париж конференциясы', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Лозанна конференциясы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Рим конференциясы', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Лондон конференциясы', isCorrect: false),]),
    UBTQuestionModel(questionId: '22', question: 'Мәнмәтін бойынша Версаль келісімшарты негізінде жеңілген мемлекеттерге жүктелген міндетті анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Шетелдермен байланысты шектеу', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Әскери жағдай енгізу', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Репарациялар төлеу', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Басқару жүйесін өзгерту', isCorrect: false),]),
    UBTQuestionModel(questionId: '23', question: 'Мәнмәтін және тарихи білімдеріңізді пайдаланып, Версаль келісімшарты негізінде Германия Познань, Померания және Жоғарғы Селезияны қайтаруға мәжбүр болған мемлекетті анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Дания', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Польша', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Литва', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Бельгия', isCorrect: false),]),
    UBTQuestionModel(questionId: '24', question: 'Мәнмітін бойынша Париж конференциясында жеңілген мемлекеттер және олармен дайындалған келісімшарттарды сәйкестендіріңіз:\n1.Германия \n2.Австрия \n3.Болгария \n4.Түркия\nА.Нейн\nӘ.Версаль\nБ.Сен-Жермен\nВ.Севр\n', options: [
      UBTOptionModel(optionId: 'A',      answer: '1-Б; 2-В; 3-Ә;4-А', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '1-Ә; 2-Б; 3-А; 4-В', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: '1-А; 2-Ә; 3-Б; 4-В', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '1-В; 2-Ә; 3-В; 4-А', isCorrect: false),]),
    UBTQuestionModel(questionId: '25', question: 'Мәнмәтін және тарихи білімдеріңізді пайдаланып, Германияға енгізген шектеуді анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Құрлық әскерін ұстауға тыйым салынды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Әскери-әуе күштері, теңіз флоттарын ұстауға тыйым салынды', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Аз ұлт өкілдерін мобилизациялауға тыйым салынды', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '50 мың адамнан артық тұратын әскер ұстауға тыйым салынды', isCorrect: false),]),
    UBTQuestionModel(questionId: '26', question: 'Ресей тарихында IIАлександр патшаның жасаған реформасы (-лары):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Янычарларды таратты', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Балтық теңізіне шығу', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Еуропаға жол ашу', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Басыбайлық құқық жойылды', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Ауылдық жерлерде өзін-өзі басқару органдарын құру', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Жоспарлы экономиканы енгізді', isCorrect: false),]),
    UBTQuestionModel(questionId: '27', question: 'Ұлы Моғол мемлекетінің құрамына кірген Үндістанның ірі ұлыстары:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Бенгал', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Үнді', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Балх', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Маратха', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Ауғанстан', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Моғол', isCorrect: false),]),
    UBTQuestionModel(questionId: '28', question: 'Қытай халқының маньчжур үстемдігіне қарсы бағытталған құпия ұйымдары:', options: [
      UBTOptionModel(optionId: 'A',      answer: '«Аспан ақыл-парасаты»', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: '«Гестапо»', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '«Ақ лотос»', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: '«Триада»', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '«Қызыл лотос»', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '«Қызыл капелла»', isCorrect: false),]),
    UBTQuestionModel(questionId: '29', question: 'XIX ғасырдың 70 жылдарындағы Ресейдегі революциялық халықшылдардың ірі теоретигі (-тері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'М.Бакунин', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Н.Муравьев', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'П.Лавров', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'А.Радищев', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Н.Тургенов', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'П.Ткачев', isCorrect: true),]),
    UBTQuestionModel(questionId: '30', question: 'Қытайда жарияланған «Үлкен секіріс» деп аталған жоспарының нәтижесі(-лері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Нарықтық экономикалық қатынастар дамыды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Ауылшаруашылығы өндіріс қысқарды', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Азамат соғысы басталды', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Үлкен секіріс жоспары күйреді', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Қытай дамыған мемлекетке айналды', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Капиталистік қатынастар дамыды', isCorrect: false),]),
    UBTQuestionModel(questionId: '31', question: 'Ежелгі Үнді әдебиетінің туындысы(-лары):', options: [
      UBTOptionModel(optionId: 'A',      answer: '«Осирис пен Исида»', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '«Нақылдар»', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '«Рамаяна»', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: '«Гильгамеш туралы дастан»', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '«Синухет әңгімесі»', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '«Махабхарата»', isCorrect: true),]),
    UBTQuestionModel(questionId: '32', question: 'Арабтар VII ғасырда бағындарған ел(-дер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Мысыр', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Бұхара', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Иран', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Сирия', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Хорезм', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Испания', isCorrect: false),]),
    UBTQuestionModel(questionId: '33', question: 'XIX ғасырдағы Еуропа әдебиетіндегі романтизмнің өкілі болған қаламгер(-лер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ж.Расин', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Дж.Байрон', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Р.Тагор', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Т.Мор', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'А.Диего', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'В.Гюго', isCorrect: true),]),
    UBTQuestionModel(questionId: '34', question: '1962 жылы 20 ақпанда АҚШ-та австронавт Джон Глен жерді айналып, алғаш орбиталық ұшуды жүзеге асырған ғарышкемесі(лері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Салют-1', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Восток-1', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Восход-2', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Мир', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Аполон-11', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Меркурий-6', isCorrect: true),]),
    UBTQuestionModel(questionId: '35', question: 'Президенттік республика бойынша президент:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'үкіметтің саяси қызметін бақылайды', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'үкіметтің жұмысын ұйымдастырады', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'мемлекеттің және атқарушы биліктің басшысы', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'сот жүйесіне бақылау орнатады', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'тек мемлекеттің басшысы', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'барлық билік жүйесін өз қолына алады', isCorrect: false),]),
  ];


  final variant2 = <UBTQuestionModel>[
    UBTQuestionModel(questionId: '01', question: 'Үлкен Сфинкс және Хефрен пирамидасы орналасқан көне мемлекет:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ежелгі Рим', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Парсы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Греция', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Мысыр', isCorrect: true),]),
    UBTQuestionModel(questionId: '02', question: 'Жүзжылдық соғыста Англияға қарсы соғысты:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Гильом Каль', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Ян Гус', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Мария Тюдор', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Жанна д Арк', isCorrect: true),]),
    UBTQuestionModel(questionId: '03', question: 'Моңғол ханы Күйікпен кездескен еуропалық саяхатшы:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'М.Поло', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Б.Диаш', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'П.Карпини', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'В.Рубрук', isCorrect: false),]),
    UBTQuestionModel(questionId: '04', question: 'Маялықтарда кең дамыған ғылым түрі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Астрономия', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Химия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Биоогия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Археология', isCorrect: false),]),
    UBTQuestionModel(questionId: '05', question: '1861 жылы ақпанда АҚШ тың оңтүстік штатында президент болып сайланды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Уоррен Гардинг', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Джефферсон Дэвис', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Томас Джефферсон', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Джеймс Монро', isCorrect: false),]),
    UBTQuestionModel(questionId: '06', question: 'XIX ғасырдың 70 жж. Солтүстік Америкада құжаттар толтыру мен келісімдерді тіпкеу үшін мемлекет жинайтын салық түрі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'гербтік', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'ұшыр', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'баж', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'оброк', isCorrect: false),]),
    UBTQuestionModel(questionId: '07', question: 'XIX ғасырдың аяғында Англиямен өнеркәсіптің дамуы бойынша теңескен меемлекет:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Италия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Франция', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Ресей', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Германия', isCorrect: true),]),
    UBTQuestionModel(questionId: '08', question: 'Буржуазиялық революция кезеңіндегі Англиядағы «диггерлер»:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'ауыл және қала кедейлерінің қозғалыстарына қатысушылар', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'шіркеудің корольге қызмет етуін айыптаушылар', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'монархияшылдар, король билігінің жақтастары', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'қала буржуазиясы мен жаңа жер иелері', isCorrect: false),]),
    UBTQuestionModel(questionId: '09', question: 'Версаль келісімшрты бойынша Германияға тыйым салынды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Конституциялық құрылысын қалпына келтіруге', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Экономикалық артықшылықтарын арттыруға', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '100 мыңнан астам әскер, әскери-әуе және теңіз флоттарын ұстауға', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Одақтас мемлекеттерінен көмек пен қолдау тауарларын қабылдауға', isCorrect: false),]),
    UBTQuestionModel(questionId: '10', question: 'Ресейдің бірінші дүниежүзілік соғыстан шығатындығы жариялаған құжатты атаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Қайта құру жарғысы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Жер туралы жарғы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Бітім туралы жарғы', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Билік туралы жарғы', isCorrect: false),]),
    UBTQuestionModel(questionId: '11', question: '1918 жылы «Спартак одағы» тобының құрған партиясы:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Коммунистік партиясы', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Демократиялық партия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Христиандық партия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Халықтық партия', isCorrect: false),]),
    UBTQuestionModel(questionId: '12', question: 'Францияда халықтық майдан үкіметін басқарған:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Генерал М.Примо де Ривера', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Социал-демократ Ф.Эберт', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Социалист Л.Блюм', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'ФКД Бас хатшысы М.Торез', isCorrect: false),]),
    UBTQuestionModel(questionId: '13', question: 'ХХ ғасырдың 30- жылдарының басындағы Жапонияның Шығыс теміржолы бойындағы бүліктері бағытталды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Моңғолияға', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Қытайға', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'КСРО ға', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'АҚШ қа', isCorrect: false),]),
    UBTQuestionModel(questionId: '14', question: 'Францияда фашистік лигаларды тарату, әскери индустрияны ішінара мемлекет меншігіне алу туралы жарғылар қабылдаған үкіметті басқарды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Э.Эррио', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Л.Блюм', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Ж.Клемансо', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'М.Торез', isCorrect: false),]),
    UBTQuestionModel(questionId: '15', question: 'Испанияда Франконың тәртібі белгіленгеннен кейін фашистік (агрессияшыл) елдердің шеңберінде қалған мемлекет', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Франция', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Англия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'КСРО', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Дания', isCorrect: false),]),
    UBTQuestionModel(questionId: '16', question: '«Тыныштандыру саясатының» құрбаны болған еуропалық мемлекет:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Польша', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Австрия', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Албания', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Норвегия', isCorrect: false),]),
    UBTQuestionModel(questionId: '17', question: 'Азаматтардың жан-жақты құқықтары мен бостандықтарын алғаш рет қорғауды заңдастырған әлемдік құжат:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Адам құқықтарының жалпыға бірдей Декларациясы', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'БҰҰ әйелдер құқықтары Конвенциясы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Адам және азамат құқықтарының Декларациясы', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Адам құқықтары туралы билль', isCorrect: false),]),
    UBTQuestionModel(questionId: '18', question: 'Кариб дағдарысының басты себебі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'НАТО-ның құрылуы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Варшава шартының құрылуы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'КСРО мен АҚШ арасындағы шиеленіс', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: '«Маршалл жоспарының» орындалмауы', isCorrect: false),]),
    UBTQuestionModel(questionId: '19', question: 'ХХ ғасырдың 50- жылдарында күшті билік және консерватизм идеясын басшылыққа алған Францияның саяси кезеңі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Француздық Коммунистік партия билігі', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Бесінші Республика билігі', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Уақытша үкімет билігі', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Төртініші Республика билігі', isCorrect: false)]),
    UBTQuestionModel(questionId: '20', question: 'ХХ ғасырдың ІІ жартысы Р.Шуман ұсынған Декларация тұжырымдамасының негізгі мәні:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Еуропалық құрылыстың тұтастығы', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Африка елдеріне гкманитарлық көмек көрсету', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Әлемде идеологиялық қарама-қайшылықтарды жою', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Отар елдердің экономикасын дамыту', isCorrect: false),]),
    UBTQuestionModel(questionId: '21', question: 'Карта бойынша тарихи үрдістің қамтитын мерзімін анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'ХІХ ғасыр', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'XVIIIғасыр', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'XV ғасыр', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'XVII ғасыр', isCorrect: false),],image: 'https://firebasestorage.googleapis.com/v0/b/history-app-777.appspot.com/o/worldHistory%2FPicture2.png?alt=media&token=a74c7816-dc9d-4997-905d-8904cfaf28bb'),
    UBTQuestionModel(questionId: '22', question: 'Картаны және тарихи білімді пайдаланып, оқиғаны анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Қырым соғысы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Ұлы елшілік', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Солтүстік соғыс', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Ақсүйектердің алтын ғасыры', isCorrect: false),]),
    UBTQuestionModel(questionId: '23', question: 'Карта жіне тарихи білімдерінізді пайдаланып, жылдар мен оқиғаларды сйкестендіріңіз\nА-1700 жыл\nӘ-1702жыл\nБ-1709жыл\n1.Полтавада орыс әскерлерінің жеңіске жетуі\n2.Орыс әскерлерінің Нева бекінісін басып алуы\n3.Шведтердің Нарвада орыс әскерін талқандауы\n', options: [
      UBTOptionModel(optionId: 'A',      answer: 'А-3,Ә-2,Б-1', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'А-2,Ә-3,Б-1', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'А-3,Ә-1,Б-2', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'А-1,Ә-2,Б-3', isCorrect: false),]),
    UBTQuestionModel(questionId: '24', question: 'Карта бойынша №1 және №2 болып белгіленіп тұрған мемлекеттерді анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Сербия және Венгрия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Финляндия және Швейцария', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Латвия және Норвегия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Литва және Эстония', isCorrect: true),]),
    UBTQuestionModel(questionId: '25', question: 'Карта және тарихи білімді пайдаланып, I Петрге қатысты дұрыс дәйектерді анықтаңыз\n1.21 жылдық соғыс нәтижесінде Швецияны толық бағындырды\n2.Еуропада сапар шеккен алғашқы орыс патшасы\n3.Реформалар арқасында мықты әскери флот сатып алды\n4.Құлдырап жатқан Ресейді теніз державасына айналдырды\n5.Ақсүйектерді толығымен әскери борыштан босатты\n', options: [
      UBTOptionModel(optionId: 'A',      answer: '2,4', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: '1,3', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '3,4', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '2,4', isCorrect: false),]),
    UBTQuestionModel(questionId: '26', question: '1899 жылы Қытайдағы тікелей көтеріліс сипатына ие болған қозғалыс(-тары):', options: [
      UBTOptionModel(optionId: 'A',      answer: '«ақ раушандар»', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '«қызыл орамалдылар»', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '«самурайлар»', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '«сары орамалдылар»', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '«тайпиндер»', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '«ихэтуаньдар»', isCorrect: true),]),
    UBTQuestionModel(questionId: '27', question: '1884-1885 жылдары Вьетнамды Қытайдан тартып алып, өз билігін орнатқан ел(-дер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ресей', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Германия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Франция', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Жапония', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Пруссия', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Англия', isCorrect: false),]),
    UBTQuestionModel(questionId: '28', question: 'XVII-XVIII ғасырларда француз қоғамындағы сословиелік топ(-тар):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ақсүйектер', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Дін қызметшілері', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Барлық азаматтар', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Рыцарьлар', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Вилландар', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Сервтер', isCorrect: false),]),
    UBTQuestionModel(questionId: '29', question: 'XIX ғ. II жартысында Ресейде капитализмнің дамуына кедергі болған саяси жүйе(-лер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'теократиялық монархия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'авторитарлық монархия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'конституциялық монархия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'парламенттік монархия', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'парламенттік республика', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'абсолюттік монархия', isCorrect: true),]),
    UBTQuestionModel(questionId: '30', question: 'АҚШ-тың қолдауымен Чан Кайши өз жақтастарымен бірге кеткен жер(-лер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Пәкістан', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Тибет', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Үндістан', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Макао', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Тайвань', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Гонконг', isCorrect: false),]),
    UBTQuestionModel(questionId: '31', question: 'Ежелгі Қытайда жарық көрген «Шицзин» шығармасының ерекшелігі(тері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Өзіндік ерекше философиясы бар', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Халық поэзиясынан бастау алған', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Әлемнің пайда болуы мен басты құдіреттер туралы айтылады', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Түпкі мәні конфуциалықтан шыққан', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Негізін культ пен құрбандық шалу туралы ілім құрады', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Мазмұнында фетишизм, магия, тотемизм сияқты наным формалары бар', isCorrect: false),]),
    UBTQuestionModel(questionId: '32', question: 'Мин әулеті кезінде Чжен Хэ саяхатының бағыты(-тары):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Араб түбектеріне', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Батыс Еуропаға', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Жапонияға', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Үндістанға', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Шығыс Африкаға', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Шығыс Еуропаға', isCorrect: false),]),
    UBTQuestionModel(questionId: '33', question: 'Жаңа буржуазиялық Англияның алғашқы ірі ойшылы(-дары):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'О.Шпенглер', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'К.Маркс', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Д.Дидро', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'В.Вольтер', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Ш.Монтескье', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Дж.Локк', isCorrect: true),]),
    UBTQuestionModel(questionId: '34', question: 'XX ғасырдың 40-50 жылдарындағы Ғылыми-техникалық революцияның алғашқы туындысы(-лары):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Нанотехнологиялық аппарат', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Ғарыштық жасанды Жер серігі', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Микромолекулалық құрылғы', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Кибернитикалық таңғажайып мүмкіндік', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Микросхемалары бар салмағы ауыр компьютер', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Электронды транзистор', isCorrect: true),]),
    UBTQuestionModel(questionId: '35', question: 'Аристотель бөліп көрсеткен мемлекеттік басқарудың бұрыс формасы(-лары):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'республикалық', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'аристократиялық', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'демократиялық', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'олигархиялық', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'тирандық', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'монархиялық', isCorrect: false),]),
  ];


  final variant3 = <UBTQuestionModel>[
    UBTQuestionModel(questionId: '01', question: 'Ежелгі Грекиядағы полис дегеніміз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'халық жиналысы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'сауда орталығы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'діни мектеп', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'қала-мемлекет', isCorrect: true),]),
    UBTQuestionModel(questionId: '02', question: 'Б.з.б I ғасырдың ортасында екіге бөлінген көшпелілер бірлестігі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'сақтар', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'сарматтар', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'үйсіндер', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'ғұндар', isCorrect: true),]),
    UBTQuestionModel(questionId: '03', question: 'Төртінші крест жорығы нәтижесінде құрылған мемлекет:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'леон корольдігі', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'кастилия корольдігі', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'латын империясы', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'эдесса графтығы', isCorrect: false),]),
    UBTQuestionModel(questionId: '04', question: 'Әль-Бакірдің дерегі бойынша Африка материгіндегі Гана елінің астанасы', options: [
      UBTOptionModel(optionId: 'A',      answer: 'лемтун', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'әль-Ғаба', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'аудагост', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'ахетатон', isCorrect: false),]),
    UBTQuestionModel(questionId: '05', question: '1860 жылы Кавур мен Ш.Наполеон арасындағы келісім бойынша Францияға берілген аймақ', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Парма және Генуя', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Болонья және Палермо', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Савойя және Ницца', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Милан және Турин', isCorrect: false),]),
    UBTQuestionModel(questionId: '06', question: '1649 жылы Англияда орын алған оқиға', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Кромвель протектараты орнады', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Республика жарияланды', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'I Карл таққа отырды', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Бірінші азаматтық соғыс басталады', isCorrect: false),]),
    UBTQuestionModel(questionId: '07', question: '1815 жылы маусымда Вена конгресінің  актісімен құрылған одақ', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Осман', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Герман', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Ағылшын', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Иран', isCorrect: false),]),
    UBTQuestionModel(questionId: '08', question: '1839-1870 жылдары Осман империсында жүргізілген жаңа реформа', options: [
      UBTOptionModel(optionId: 'A',      answer: 'меджлис', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'жаңа османдар', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'танзимат', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'жаңа бағыт', isCorrect: false),]),
    UBTQuestionModel(questionId: '09', question: 'Австрия-Венгрия империясының ыдырауы нәтижесінде пайда болған мемлекет', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Швеция', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Чехословакия', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'дания', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'бельгия', isCorrect: false),]),
    UBTQuestionModel(questionId: '10', question: 'Мұстафа Кемалдің білім беру реформаларындағы маңызды жаңалықтарының бірі', options: [
      UBTOptionModel(optionId: 'A',      answer: 'жаппай жоғарғы білім беру', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'медреселерде оқытуды жандандырды', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'жалпыға бірдей арнаулы мамандыққа даярлау', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'түрікттердің латын әліпбиіне көшуі', isCorrect: true),]),
    UBTQuestionModel(questionId: '11', question: 'АҚШ-тағы «Жаңа Бағыттың» жұмыссыздар үшін маңызды бағыттарының бірі', options: [
      UBTOptionModel(optionId: 'A',      answer: 'несиелік қарыздарды кешіру', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'қоғамдық жұмыстарды ұйымдастыру', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'шетелдерге жұмыс күші ретінде жіберу', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'ақылы демалысқа жіберу', isCorrect: false),]),
    UBTQuestionModel(questionId: '12', question: 'АҚШ Президенті Г. Гувер дүниежүзілік экономикалық дағдарыс кезінде', options: [
      UBTOptionModel(optionId: 'A',      answer: '«жаңа бағыт» саясатын ұсынды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'әлеуметтік экономикалық мәселелерді шеше алмады', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'дағдарысты тез арада тоқтата алды', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'әлеуметтік-эконрмикалық мәселелерді шеш алды', isCorrect: false),]),
    UBTQuestionModel(questionId: '13', question: '1919-1920 жылдары Италияда орын алған революциялық дағдарыс аталды:', options: [
      UBTOptionModel(optionId: 'A',      answer: '«қызыл екіжылдық»', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: '«зая кеткен екі жыл»', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '«ұлы бетбұрыс»', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '«қараңғы екіжылдық»', isCorrect: false),]),
    UBTQuestionModel(questionId: '14', question: 'Синхай революциясының ең ірі ошағы болған қала:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Пекин', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Учан', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Шанхай', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Үрімші', isCorrect: false),]),
    UBTQuestionModel(questionId: '15', question: '1939 жылы Антикоминтери пактісіне қосылған мемлекет', options: [
      UBTOptionModel(optionId: 'A',      answer: 'венгрия', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'болгария', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'хорватия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'румыния', isCorrect: false),]),
    UBTQuestionModel(questionId: '16', question: 'Екінші дүниежүзілік соғыс қарсаңында Тынық мұхит аймағы мен Қиыр Шығысты  түбегейлі иеленбек болған мемлекет', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Қытай', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Жапония', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Англия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'франция', isCorrect: false),]),
    UBTQuestionModel(questionId: '17', question: '1961 жылы Германияда орын алған жағдай:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'ГДР Варшава шартына қол қойды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Германия екіге бөлінді', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'ГФР НАТО-ға мүше болды', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Берлин қабырғасы тұрғызылды', isCorrect: true),]),
    UBTQuestionModel(questionId: '18', question: 'Қазіргі кезде ТМД елдерінің әскери ынтымақтастығын жүзеге осырып отырған ұйым:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'ҰҚКҰ', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'ШЫҰ', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'ЕҚЫҰ', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'ЕЭҚ', isCorrect: false),]),
    UBTQuestionModel(questionId: '19', question: '«Қырғиқабақ  соғыстың» аяқталуымен байланысты емес тарихи оқиға', options: [
      UBTOptionModel(optionId: 'A',      answer: 'КСРО ның ыдырауы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'ВШҰ ның қызметінің тоқтауы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'екіге бөлінуі', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'биполярлы жүйенің құлауы', isCorrect: false)]),
    UBTQuestionModel(questionId: '20', question: 'М. Тэтчер басқарған консервативті үкіметтің бюджет тапшылығын жою үшін жүргізген шарасы', options: [
      UBTOptionModel(optionId: 'A',      answer: 'тікелей салықты көбейту', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Экономиканы национализациялау', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'шетелге капитал шығаруға шек қою', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'әлеуметтік шығындар мен субсидияларды қысқару', isCorrect: true),]),
    UBTQuestionModel(questionId: '21', question: 'Контекст\nКестені және тарихи білімдеріңізді пайдаланып, екінші дүниежүзілік соғыстан кейін әлеуметтік-эконмикалық реформалар жүргізілген елді анықтаңыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'ұлыбритания', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'франция', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'германия', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'италия', isCorrect: false),]),
    UBTQuestionModel(questionId: '22', question: 'Кестені және тарихи білімдеріңізді пайдаланып, екінші дүниежүзілік соғыстан кейінгі Германияда жүргізілген рефорамныңғылыми бағытын анықтағыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Монетаризм', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Некосерваторизм', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Ордолиберазим', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Нелиберализм', isCorrect: false),]),
    UBTQuestionModel(questionId: '23', question: 'Кестені және тарихи білімдеріңізді пайдаланып,екінші дүниежүзілік соғыстан кейінгі Батыс Германияда жүргізілген экономикалық реформаның мақсатын анықтаңыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Маркистік теорияға негізделген экономиканы құру', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Экономикадағы  мемлекетің үлесін көбейту', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Әскери экономикадан нарықтық экономикаға өту', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Экономиканы милитарландыру', isCorrect: false),]),
    UBTQuestionModel(questionId: '24', question: 'Кестені және тарихи білімдеріңізді пайдаланып,батыс Германияда ақша реформасын жүргізудегі міндетті анықтаңыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'валюта девальвациясын жұщеге асыру', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'рейхемарканың құнсыздануын тоқтату', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'ақшаның шаруашылық аналымындағы рөлін қалпыну келтіру', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'батыс елдерімен бірыңғай ортақ валюта ашу', isCorrect: false),]),
    UBTQuestionModel(questionId: '25', question: 'Кестені және тарихи білімдеріңізді пайдаланып,соғыстан кейін батыс Германияда жүргізілген экономикалық реформаның нәтижесін анықтаңыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'жоспарлы экономика қалыптасты', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'экономикалық өсім байқалмады', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'реформаның айтарлықтай нәтижесі болады', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'экономиканың дамыған елге айналды', isCorrect: true),]),
    UBTQuestionModel(questionId: '26', question: '1894 жылы «Қытайды қайта өркендету қоғамын» құрған қайраткер(-лер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ли Куан Ю', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Кан Ювей', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Юан Шикай', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Сун Ятсен', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Гуансюй', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Лян Цичао', isCorrect: false),]),
    UBTQuestionModel(questionId: '27', question: 'XIX ғ. соңына қарай Осман империясының әлсіреу салдарынан Англияның түріктерден тартып алған жері(-лері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Румыния', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Алжир', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Сербия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Болгария', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Мысыр', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Тунис', isCorrect: false),]),
    UBTQuestionModel(questionId: '28', question: 'Отто фон Бисмарктың саясатына қарсы бағыт ұстанған партия(-лар):', options: [
      UBTOptionModel(optionId: 'A',      answer: '«Коммунистік»', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '«Ұлттық-либералдық»', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '«Империялық»', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '«Еркін консерваторлар»', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '«Герман демократиялық»', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '«Еркін ойлаушылар»', isCorrect: true),]),
    UBTQuestionModel(questionId: '29', question: '1815 жылы 18 маусымда Францияға қарсы жетінші одақ әскерлерінің шайқасы өткен жер(-лер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Аустерлиц', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Тильзит', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Трафальгар', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Лейпциг', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Бородино', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Ватерлоо', isCorrect: true),]),
    UBTQuestionModel(questionId: '30', question: '30.Дэн Сяопиннің «бір ел-екі жүйе» ұстанымы негізінде біріктіруді ұсынған аймақ(-тар):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Бирма', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Мьянма', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Тайланд', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Аомынь', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Сянган', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Тайвань', isCorrect: true),]),
    UBTQuestionModel(questionId: '31', question: 'Жастық шақта рақаттан, ересек жаста даудан, қартайғанда сарандықтан сақ болуға шақырған философ(-тар):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Лао Цзы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Конфуций', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Сократ', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Аристотель', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Цицерон', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Платон', isCorrect: false),]),
    UBTQuestionModel(questionId: '32', question: 'Қайта өрлеу дәуірінде Италиядағы басты мәдениет орталығына айналған қала(-лар):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Флоренция', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Рим', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Генуя', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Милан', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Венеция', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Сардиния', isCorrect: false),]),
    UBTQuestionModel(questionId: '33', question: 'Италяндық опера өнерінің Ұлы классигі Джузеппе Вердидің шығармасы(-лары):', options: [
      UBTOptionModel(optionId: 'A',      answer: '«Аида»', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: '«Қылмыс пен жаза»', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '«Өлі жандар»', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '«Травиата»', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: '«Граф Монткристо»', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '«Отелло»', isCorrect: true),]),
    UBTQuestionModel(questionId: '34', question: 'Бұқаралық мәдениеттің негізгі құрамдас бөлігі(-тері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ой-пікір еркіндігі', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Міндетті білім алу индустриясы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Жаппай тұтынуды қалыптастыру жүйесі', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Бос уақытты өткізу индустриясы', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Ақпараттық индустрия', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Демалу ойын-сауық еркіндігі', isCorrect: true),]),
    UBTQuestionModel(questionId: '35', question: 'Құқықтық мемлекеттің мақсаты(-тары):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Билікті асыра пайдалануға жол бермеу', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Азаматтық қоғам жүйесін шектеу', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Теократиялық жүйені қорғау', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Соттарға бақылау жасау', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Азаматтардың құқығын қамтамасыз ету', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Цензураны қорғау', isCorrect: false),]),
  ];


  final variant4 = <UBTQuestionModel>[
    UBTQuestionModel(questionId: '01', question: 'Месопотамияда Аккад мемлекетінің негізін қалаушылар:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Шумерлер', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Ежелгі Римдіктер', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Египетіктер', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Парсылар', isCorrect: false),]),
    UBTQuestionModel(questionId: '02', question: 'XV ғасырдың соңында Пиреней түбегіндегі жойылған соңғы мұсылман  мемлекет:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Эдесса корольдігі', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Гранада корольдігі', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Триподи корольдігі', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Кастилия корольдігі', isCorrect: true),]),
    UBTQuestionModel(questionId: '03', question: 'XVII ғасырдың екінші жартысында Францияда түпкілікті орнады:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Парламенттік монархия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Теократиялық монархия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Шексіз абсалюттік монархия', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Президенттік республика', isCorrect: false),]),
    UBTQuestionModel(questionId: '04', question: 'XV ғасырдың соңында Африканы айнала жүзіп, алғаш Үндістанға жеткен еуропалық саяхатшы:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Фернан Магеллан', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Васко да Гама', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Бартоломеу Диаш', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Христофор Колумб', isCorrect: false),]),
    UBTQuestionModel(questionId: '05', question: '«Өнеркәсіп төңкерісі», «Индустриландыруды» негізге ала отырып, XIX ғасырға қоғамның берген атауы:', options: [
      UBTOptionModel(optionId: 'A',      answer: '«өрлеу» ғасыры', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '«азаттық» ғасыры', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '«темір» ғасыры', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: '«техника» ғасыры', isCorrect: false),]),
    UBTQuestionModel(questionId: '06', question: 'Солтүстік Америкада құлдардың еңбегін кеңінен қолданған отарлар орналасты:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'солтүстігінде', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'шығысында', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'оңтүстігінде', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'батысында', isCorrect: false),]),
    UBTQuestionModel(questionId: '07', question: 'АҚШ-қа 1864 жылы  солтүстік әскердің бас қолбасшысы болып тағайындалды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Т. Джефферсон', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Д. Дэвис', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'А. Линкьолн', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'У. Грант', isCorrect: true),]),
    UBTQuestionModel(questionId: '08', question: 'Азамат соғысынан кейінгі АҚШ-тың экономикалық даму деңгейі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'құлиелунушілік', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'феодалдық', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'аграрлық', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'индустриялық', isCorrect: true),]),
    UBTQuestionModel(questionId: '09', question: 'Ұлттар Лигасының міндеттерінің бірі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'үлкен және кіші, жеңген және жеңілген елдердің барлығына бірдей экономикасын дамыту', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'елдер арасында ынтымақтастықты дамыту мен бейбітшілікті сақтау', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Еуропадағы жеңген державалардың пайдасын бөлу, әскери күштерін шектеу', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'елдердің техникалық-экономикалық артта қалушылығын жою', isCorrect: false),]),
    UBTQuestionModel(questionId: '10', question: '1920 жылы Түркия Ұлы Ұлттық мәжілісінің отырыс өткен қала:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Анкара', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Измир', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Кайсери', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Стамбул', isCorrect: false),]),
    UBTQuestionModel(questionId: '11', question: 'Бірінші дүниежүзілік соғыс нітижесінде «жеңгендердің арасындағы жеңілген ел» атанған мемлекет:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ұлыбритания', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Испания', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Франция', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Италия', isCorrect: true),]),
    UBTQuestionModel(questionId: '12', question: '1936-1938  жылдары  Халық майданының үкіметтері құрылған елдер', options: [
      UBTOptionModel(optionId: 'A',      answer: 'АҚШ, Франция, Германия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'КСРО, Испания, Португалия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Франция, Испания, Чили', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Ұлыбритания, Испания, Чили', isCorrect: false),]),
    UBTQuestionModel(questionId: '13', question: '1929 жылы АҚШ-та басталды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'экономикалық даму', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'азамат соғысы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'экономикалық дағдарыс', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'мәдени төңкеріс', isCorrect: false),]),
    UBTQuestionModel(questionId: '14', question: 'АҚШ Президенті Ф.Д. Рузвельт дүниежүзілік экономикалық дағдарыс кезінде', options: [
      UBTOptionModel(optionId: 'A',      answer: 'президенттік қызметінен бас тартты', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'халықаралық валюта қорынан қарыз алды', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'әлеуметтік-экономикалық мәселелерді шеше алады', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '«Жаңа бағыт» деп аталатын саясатын ұсынды', isCorrect: true),]),
    UBTQuestionModel(questionId: '15', question: '1939 жылы көктемде Еуропада Мюнхен келісімінің бұзылу нәжитежесінде Германия басып алған мемлекет', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Румыния', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Болгария', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Польша', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Чехословакия', isCorrect: true),]),
    UBTQuestionModel(questionId: '16', question: 'Алдарына геосаяси мақсат қойып, әлемге билігін орнату үшін Версаль-Вашингтон жүйесіне өзгеріс енгізбек болған мемлекеттер:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Испания, Италия және Қытай', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Румыния, Испания және Жапония', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Германия, Румыния және Испания', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Германия, Италия және Жапония', isCorrect: true),]),
    UBTQuestionModel(questionId: '17', question: 'Маршалл жоспарын жүзеге асыру үшін құрылған тұрақты халықаралық ұйым:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Варшава шарты', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Еуропалық экономикалық ынтымақтастық ұйымы', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'НАТО', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Шығыс Еуропа елдерінің экономикалық ұйымы', isCorrect: false),]),
    UBTQuestionModel(questionId: '18', question: 'Азаматтардың құқықтары мен бостандықтары туралы әлемдік құжаттарды қабылданған мерзімдерімен сәйкестендіріңіз.\n1.Адам құқықтарының жалпыға бірдей Декларациясы\n2.Экономикалық, әлеуметтік және мәдени құқықтар жөніндегі халықаралық пакт\n3.Бала құқықтары туралы Конвенция\nА-1948ж \nӘ-1959ж \nБ-1966ж\n', options: [
      UBTOptionModel(optionId: 'A',      answer: '1-ә,2-б,3-а', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '1-б,2-а,3-ә', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '1-а,2-б,3-ә', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: '1-б,2-ә,3-а', isCorrect: false),]),
    UBTQuestionModel(questionId: '19', question: 'Экономикадағы «шведтік үлгі» терминінің пайда болуына негіз болған фактор', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Швециядағы ұлтаралық шиеленіс', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Швециядағы жылдам экономикалық өсім', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Швециядағы жұмысшылар қозғалысы', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Швецияның социалистік әлемнен жақындауы', isCorrect: false)]),
    UBTQuestionModel(questionId: '20', question: 'XX ғасырдың II жартысында Батыс Германияда жұмыс күшінің жетіспеушілігін жоюға байланысты  қабылданған шаралар', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Балар еңбегін пайдаланды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Шетелден жұмыссыздардың келуіне рұқсат етілді', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Еңбек міндеткелігін енгізді', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Өндіріс орындарының санын қысқартты', isCorrect: false),]),
    UBTQuestionModel(questionId: '21', question: 'КОНТЕКСТ\nКесте бойынша әлемдегі геосаяси жағдайдың өзгеруіне байланысты ағылшын протектораты орнаған елді анықтаңыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Түркия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Сирия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Египет', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Алжир', isCorrect: false),],image: 'https://firebasestorage.googleapis.com/v0/b/history-app-777.appspot.com/o/worldHistory%2FScreenshot%202024-05-30%20at%2016.15.00.png?alt=media&token=5b21fac1-0e27-4322-97ff-8fa768df37f3'),
    UBTQuestionModel(questionId: '22', question: 'Кестені пайдаланып француз мандаты сақталған елді анықтаңыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Египет', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Ирак', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Сирия', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Тунис', isCorrect: false),]),
    UBTQuestionModel(questionId: '23', question: 'Кестені және тарихи білімдеріңізді пайдаланып, 1936 жылы келісім бойынша Сирияның Францияға берген рұқсатын анықтаңыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Сириялық, парламентте сайлануға', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Кедендік, қаржы істерін бақылауда ұстауға', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Әскери мен әскери базаларын сақтауға', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Қаруды күштері толық жоюға', isCorrect: false),]),
    UBTQuestionModel(questionId: '24', question: 'Кестені және тарихи білімдеріңізді пайдаланып, 1918 жылы Египетте құрылған Вафд партиясының талабын анықтағыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Жаңа кедендік салық жүйесін енгізу', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Ұлттық туелсіздікті беру', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Әлеуметтік мәселелерді шешу', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Сауда жолдарын пайдалуға беру', isCorrect: false),]),
    UBTQuestionModel(questionId: '25', question: 'Кестені және тарихи білімдеріңізді пайдаланып,XX ғасырдың 30 жылдарының аяғында Сирия мен Египеттің сыртқы саясатындағы ұқсастықты анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Мандаттық, протектораттың биліктен толық құтылды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Өз жерлерінде француз, ағылшын әскерлерін ұстауға толық шек қойды', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Шетелдіктердің араласуына қарсы бағытталған күрестер толық тоқтады', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Отарлаушы елдердің ықпалында қалды', isCorrect: true),]),
    UBTQuestionModel(questionId: '26', question: 'XIX ғасырда Ресейде орын алған  «Солтүстік одақтың» мүшесі', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Н.И Тургенов', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'П.Н Ткачев', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'М.П Бестужев-Рюмин', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'П.Л Лавров', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'М.Муравьев', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'А.Н Радишев', isCorrect: false),]),
    UBTQuestionModel(questionId: '27', question: '1884-1885 жылдары Қытайға соғыс ашқан ел:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Испания', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Италия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Германия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Франция', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Португалия', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Англия', isCorrect: false),]),
    UBTQuestionModel(questionId: '28', question: 'XVII ғасырдағы Францияның мемлекеттік құрылысы:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'республика', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'президенттік республика', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'теократтиялық монархия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'абсалюттік монархия', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'парламенттік республика', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'конституциялық монархия', isCorrect: false),]),
    UBTQuestionModel(questionId: '29', question: '1825 жылы Ресейде орын алған декабристер көтерілісінің мақсаты', options: [
      UBTOptionModel(optionId: 'A',      answer: 'жұмысшылар  еңбек жағдайын жақсарту', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'самодержавиені орнату', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Николайға ант қабылдауына жол бермеу', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Патшаға қарсы көтеріліс', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'азаматтық бостандықтарды жариялау', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'кәсіп орындарды басып алу', isCorrect: false),]),
    UBTQuestionModel(questionId: '30', question: 'XX ғасырдың 70-90 жж. Жаңа индустриалды елдер қатарына кірген елдер', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Сингапур', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Оңтүстік Корея', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Малайзия', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Пәкістан', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Үндістан', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Вьетнам', isCorrect: false),]),
    UBTQuestionModel(questionId: '31', question: 'Ежелгі үнділіктер бірінші болып игерді', options: [
      UBTOptionModel(optionId: 'A',      answer: 'қант құрағынаан қант өсіруді', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'құбысламаны пайдалануды', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'кітап басуды', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'мақтадан мата алуды', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'жібектен кілем тігуді', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'желкенді кілем жасауды', isCorrect: false),]),
    UBTQuestionModel(questionId: '32', question: 'Қайта өрлеу дәуірінде атақты «Құдыретті комедиясын» жазған:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Донателло', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Рафаэль Санти', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Микаленджелло Буонаротти', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Данте', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Джото ди Бондоне', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Леонардо да Винчи', isCorrect: false),]),
    UBTQuestionModel(questionId: '33', question: 'Еуропалық жаңа заман ағартушыларының дінге көзқарасы', options: [
      UBTOptionModel(optionId: 'A',      answer: 'дүниені құдайдың жаратқанына сенді', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'жанның өлмейтіндігіне сенбейді', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'шіркеуді сынға алды', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'құдайға сену еш уақытта жойылмайды деп есептеді', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'құдайға сену табиғаттың барлық құпиялары ашлығанда жойылады деп есептеді', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'католик шіркеуін қолдады', isCorrect: false),]),
    UBTQuestionModel(questionId: '34', question: 'Мұнай экспорттаушы ел', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Тунис', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Эфопия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Кувейт', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Катар', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Бахрейн', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Мадагаскар', isCorrect: false),]),
    UBTQuestionModel(questionId: '35', question: 'Әсіре ұлтшылдықтың түрі', options: [
      UBTOptionModel(optionId: 'A',      answer: 'шовинизм', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'тобырлық', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'нәсілшілдік', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'абозидицианизм', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'атеизм', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'космополит', isCorrect: false),]),
  ];


  final variant5 = <UBTQuestionModel>[
    UBTQuestionModel(questionId: '01', question: 'Қант құрағынан қант өндіруді әлемде алғаш игерген мемлекет:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Жапония', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Қытай', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Бирма', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Үндістан', isCorrect: true),]),
    UBTQuestionModel(questionId: '02', question: 'XIV ғасырда Еуропа тұрғындарының үштен бірінің қазаға ұшырау себебін себебін анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Табиғи апаттан', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Ашаршылықтан', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Қара індеттен', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Жүзжылдық соғыстан', isCorrect: false),]),
    UBTQuestionModel(questionId: '03', question: 'Монғол ханы Мөңкемен кездескен еуропалық саяхатшы:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'П.Карпини', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Б.Диаш', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'М.Поло', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'В.Рубрук', isCorrect: true),]),
    UBTQuestionModel(questionId: '04', question: 'XI ғасырда Нигер және Бакой өзендерінің аралығында құрылған шағын мемлекет:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Сонгай', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Мали', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Гана', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Нубия', isCorrect: false),]),
    UBTQuestionModel(questionId: '05', question: 'XIX ғасырда Германияда батрактар еңбегін пайдаланған және ішкі нарыққа тауарларды жеткізіп отырған ауқатты шаруалар', options: [
      UBTOptionModel(optionId: 'A',      answer: 'рекруттар', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'гроссбауэрлер', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'граттар', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'латифундистер', isCorrect: false),]),
    UBTQuestionModel(questionId: '06', question: 'Батыста капиталистік қатынастар пайда болды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Франциядағы революция нәтижесінде', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Өнеркәсіп төңкерісі нәтижесінде', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Англиядағы Азаматтық соғыс нәтижесінде', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Абсолютизмнің құлау нәтижесінде', isCorrect: true),]),
    UBTQuestionModel(questionId: '07', question: 'Индустриялық өркениеттің отаны:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Англия', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Германия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'АҚШ', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Франция', isCorrect: false),]),
    UBTQuestionModel(questionId: '08', question: '1878 жылы ақпанда парламентті таратып, елді жеке өзі билейтінін жария еткен түрік сұлтаны:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'IIМахмұт', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'II Абдул Хамид', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Намык Кемал', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Абдул Меджид', isCorrect: false),]),
    UBTQuestionModel(questionId: '09', question: '1917 жылы сәуір айында дүниежүзілік соғысқа араласқан мемлекет:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Болгария', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Ресей', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'АҚШ', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Канада', isCorrect: false),]),
    UBTQuestionModel(questionId: '10', question: 'Ресейде «мықты билікті» қалпына келтіру және большевиктердің билікке келуіне жол бермеу мақсатында ұйымдастырылған көтерілісті басқарды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Бакунин', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Петрашевский', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Корнилов', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Декабристер', isCorrect: false),]),
    UBTQuestionModel(questionId: '11', question: 'Кеңестік басшылықтың Германиямен пакт жасау шешімімен қабылдауына итермелеген себепті анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'КСРО-ның экономикалық күш-қуатының әлсіз болуы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Англия және Франциямен келісім жасауына Жапонияның кедергі болу қаупінің туындауы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Англия мен Францияның КСРО-мен келісімге қол қоймайтынына көз жеткізуі', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Францияның КСРО-мен келісімге келуге қолдау жасауы', isCorrect: false),]),
    UBTQuestionModel(questionId: '12', question: 'Францияда 1936 жылы сайлауда жеңіске жетті:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Халықтық майдан партиялары', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Фашистік партиялар', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Демократиялық партия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Республикалық партия', isCorrect: false),]),
    UBTQuestionModel(questionId: '13', question: '1937-1938 жылдары барлық беделді тұлғаларға тағылған айып:', options: [
      UBTOptionModel(optionId: 'A',      answer: '«өзгеше ойлайтындар»', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '«ұлтшыл-фашист» және «тыңшы»', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: '«революцияшыл пиғылдағылар»', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '«сенімсіз желтоқсаншылар»', isCorrect: false),]),
    UBTQuestionModel(questionId: '14', question: 'XX ғасырдың басындағы Үнді Ұлттар Конгресі мен Мұсылмандар лигасының ұқсас талаптарының бірі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ұлттық милиция құру', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Президенттік мемлекет құру', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Ағылышын тілінің артықшылықтарын жою', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Өзін-өзі басқару құқығын алу', isCorrect: true),]),
    UBTQuestionModel(questionId: '15', question: 'Антигитлерлік коалицияның құрылуының алғышарты:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Германияда гитлерлік билікке қарсы бағытталған буржуазиялық күштерге қолдау көрсету', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Германияда коммунистік қозғалыстың көмегімен Гитлерді биліктен шеттету', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Фашизмге қарсы бағытталған халықаралық ұйым құру', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Англия мен АҚШ тарапынан Германияға қарсы соғыста КСРО-ға қолдау көрсету', isCorrect: true),]),
    UBTQuestionModel(questionId: '16', question: 'Германдық Богемия мен Моравия протектораты құрылған аумақ:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Югославия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Норвегия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Румыния', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Чехия', isCorrect: true),]),
    UBTQuestionModel(questionId: '17', question: '1954-1962 жж. Франция мен Алжир арасында соғыстың туындауына түрткі болған жағдай:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Франция Конституциясына өзгерістердің енгізілуі', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Алжирден келген иммигранттар санының көбеюі', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Францияның отарларымен әскери келісімшарттар жасауы', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Алжирде ірі мұнай кен орындарының табылуы', isCorrect: true),]),
    UBTQuestionModel(questionId: '18', question: 'КОКП-ның XX сьезінде сынға алынған мемлекеттік басқару әдісі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'диктаторлық', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'демократиялық', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'либералдық', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'радикалдық', isCorrect: false),]),
    UBTQuestionModel(questionId: '19', question: 'Отарлық жүйенің ыдырауына себепші болған саяси фактордың ерекшелігін анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Отар елдердің шикізат көзіне айналуы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Отар елдерде жергілікті буржуазияның қалыптасуы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Метрополияларда тау-кен өнеркәсібінің дамуы', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Батыс елдерінде демократияның артуы', isCorrect: true)]),
    UBTQuestionModel(questionId: '20', question: 'XX ғасырдың 60-70 жылдары Ұлыбритания лейбористері жүргізген реформаларға елеулі әсер еткен Дж.Кейнс идеялары:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Экономиканы милитарландыру', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Экономикаға мемлекеттік монополия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Табиғи монополияны қолдау', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Бәрін жұмыспен қамту, халықтың жоғары табысы', isCorrect: true),]),
    UBTQuestionModel(questionId: '21', question: 'Иван Грозный\nҰлы Василий князь өлгеннен кейін орыс мемлкетінде өкімет билігі үшін күрес күшейе түсті. Таққа сөз жүзінде үш жасар IV Иван (1533-1584) не болды да, іс жүзінде мемлекетті оның шешесі Елена Глинская мен кеңесшілері басқарды. 1547 жылдан IV Иван орыс мемлекетінің патшасы атанды. Ол самодержавиені нығайту үшін жаңадан заңдар жинағын шығарды. Бұрынғы боярлар думасының орнына Зем соборын құрды. Боярлардың саяси билігі төмендетіліп, дворяндардың билігі күшейтілді. Әскери реформа жүргізіліп, Ресейде тұрақты армия құрылды. Ел басқару жүйесіне приказдар жүйесі енгізіліп, Ресей бір орталықтан бағындырылған мемлекетке айналды. Абсолюттік монархия елді орыс дворяндарына сүйеніп басқарды. Зем жиналысы, шіркеу мен боярлар думасының беделі әлсіреп, абсолютті монархия шексіз билікке ұласты. Ол елде опричнина саясатын енгізді. IVИванды халық Грозный деп атады.\nМәнмәтін бойынша IV Иванның тұсында саяси билігі төмендеген әлеуметтік топты анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Дворяндар', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Помещиктер', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Мешанлар', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Боярлар', isCorrect: false),],image: 'https://firebasestorage.googleapis.com/v0/b/history-app-777.appspot.com/o/worldHistory%2Fworldh.png?alt=media&token=f171660b-f8ff-4e5d-b2c9-true'),
    UBTQuestionModel(questionId: '22', question: 'Мәнмәтін бойынша IV Иван самодержавиені нығайту үшін құрды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Зем соборын', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Сенатты', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Боярлар думасын', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Бас штатты', isCorrect: false),]),
    UBTQuestionModel(questionId: '23', question: 'Мәнмәтін бойынша XVI ғасырдың екінші жартысындағы Ресейдегі саяси жағдайды анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Бір орталыққа бағындырылған  мемлекет', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Бытыраңқы мемлекет', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Конституциялық монархия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Парламенттік республика', isCorrect: false),]),
    UBTQuestionModel(questionId: '24', question: 'Мәнмәтін бойынша Иван Грозныйдың Ресейдің әскери саласында жүргізген реформасын анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Теңіз державасына айналдырды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Теңіз флотын күшейтті', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Жалдамалы әскер жасақтады', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Тұрақты армия құрды', isCorrect: true),]),
    UBTQuestionModel(questionId: '25', question: 'Мәнмәтін бойынша Иван Грозныйдың дін саласына жүргізген саясатын анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Митрополиттердің рөлін күшейтті', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Шіркеу билігін күшейтті', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Шіркеу билігін өз қолына алды', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Діни оқу орындарын көбейтті', isCorrect: false),]),
    UBTQuestionModel(questionId: '26', question: 'Вена конгресінің шешімі бойынша Италиядан бөлініп шыққан мемлекет(-тер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Бургундия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Кордова корольдігі', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Каталония', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Марокко', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Сардиния корольдігі', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Тоскана', isCorrect: true),]),
    UBTQuestionModel(questionId: '27', question: '1789 жылы Францияда орын алған аса маңызды оқиға(-лар):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Теократиялық билік орнады', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Бурбондар әулеті билікке келді', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Наполеон өзін император деп жариялады', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Абсолюттік монархия құлады', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Бас штаттар таратылды', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Бастилия құлатылды', isCorrect: true),]),
    UBTQuestionModel(questionId: '28', question: 'XIX ғ. I жартысында Ресейде болған соғыс(-тар):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Отан', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Солтүстік', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Ливон', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Қырым', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Азамат', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Балқан', isCorrect: false),]),
    UBTQuestionModel(questionId: '29', question: '1814 жылғы Вена Конгресінде жетекші рөл атқарған ел(-дер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Италия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Англия', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Грекия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Польша', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Ресей', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Франция', isCorrect: false),]),
    UBTQuestionModel(questionId: '30', question: 'Демократизм мен зайырлылық қағидаттарына негізделген Үндістан Конституциясында қатаң тыйым салынған кемсітушілік(-тер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'тұлғалық', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'ұлттық', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'аумақтық', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'касталық', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'нәсілдік', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'тілдік', isCorrect: false),]),
    UBTQuestionModel(questionId: '31', question: 'Сына жазуы ең алғаш пайда болды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Үндістанда', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Мысырда', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Солтүстік Месопотамияда', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Оңтүстік Қытайда', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Оңтүстік Месопотамияда', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Бактрияда', isCorrect: false),]),
    UBTQuestionModel(questionId: '32', question: 'Т.Мордың 1516 жылы жарық көрген «Мемлекетті жақсы ұйымдастыру және жаңа Утопия аралы туралы алтын кітабы» атты шығармасының негізгі тақырыбы:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Англиядағы қайыршылық жағдайды сынға алды', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Білім алу ақсүйектердің ғана маңдайына жазылған деп есептеді', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Франция мен Англия арасындағы «жүз жылдық соғысты» сынады', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Мемлекеттің жеке адам мүддесімен санаспауды қолдады', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Бай мен кедейге бөлінуді жоққа шығарды', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Деспоттық басқару жүйесін қолдады', isCorrect: false),]),
    UBTQuestionModel(questionId: '33', question: 'XVIII ғасырдың бірінші жартысындағы француз ағартушысы(-лары):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ф.Вольтер', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Ш.Монтескье', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Ф.Гизо', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Т.Гоббс', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'А.Гумбольт', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Ж.Гобино', isCorrect: false),]),
    UBTQuestionModel(questionId: '34', question: 'XX ғасырдың 60-80 жылдарындағы Латын Америкасы әдебиетінің өкіл(-дері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Г.Маркес', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Х.Кортасар', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Х.Борхес', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Э.Хемингуэй', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Ф.Мориак', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'У.Фолькнер', isCorrect: false),]),
    UBTQuestionModel(questionId: '35', question: 'Тоталитаризмнің белгісі(-лері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Идеологиялық біртұтас басқарудың болмауы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Жекелеген цензураның сақталуы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Жетілдірілген жазалау жүйесі', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Жүйелі сайлау- билік органдарының негізі', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Бәрін қамтыған идеология', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Идеялық плюрализм және пікір бәсекелестігі', isCorrect: false),]),
  ];


  final variant6 = <UBTQuestionModel>[
    UBTQuestionModel(questionId: '01', question: 'Перғауынның діни рәсімдері атқарғанына байланысты иеленген атақ:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Күн Нұры', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Тәңір Құты', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Құдыретті күш', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Күн ұлы', isCorrect: true),]),
    UBTQuestionModel(questionId: '02', question: 'XV ғасырдағы Батыс және Орталық Еуропадағы котолик шіркеуіне қарсы қуатты қоғамдық саяси және діни қозғалыс:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Инквизация', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Реформация', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Индульгенция', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Реконкиста', isCorrect: false),]),
    UBTQuestionModel(questionId: '03', question: 'IX-X ғасырларда Батыс Еуропа елдерінде қалыпасқан қоғамдық құрылыс:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'капиталистік', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'феодалдық', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'құлиелушілік', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'алғашқы қауымдық', isCorrect: false),]),
    UBTQuestionModel(questionId: '04', question: 'Географиялық ашулар нәтижесінде Еурапода тауар өндіруді жеделдетуге біршама ықпал етті:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Отарлық басқыншылық', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Мәдени төңкеріс', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Ұлы дүрбелен', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Қайта өрлеу', isCorrect: false),]),
    UBTQuestionModel(questionId: '05', question: '1787 жылы елді республика ретінде жариялаған Конституциясы қабылдаған ел:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Жапония', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Англия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'АҚШ', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Франция', isCorrect: false),]),
    UBTQuestionModel(questionId: '06', question: 'Жапонияның «жабық есік» соғылған мерзімі:', options: [
      UBTOptionModel(optionId: 'A',      answer: '265', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: '300', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '215', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '235', isCorrect: false),]),
    UBTQuestionModel(questionId: '07', question: 'XVII ғасырдың 30-жылдарының соңы мен 40-жылдарының бас кезінде Англия қоғамында қалыптасқан ойлар:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'демократиялық', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'революциялық', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'әлеуметтік', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'тұрақтылық', isCorrect: false),]),
    UBTQuestionModel(questionId: '08', question: 'Францияда 1848 жылы болған революция нәтижесі', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Абсалютті монархия орнықты', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Республика жарияланды', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Бірінші империя орнады', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Конституциялық монархия орнықты', isCorrect: false),]),
    UBTQuestionModel(questionId: '09', question: 'Вашингтон конференциядасында Қытайдың пен аумақтық тұтастығы қағидасын жариялаған келісімшарт:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Төрт держава трактаты', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Үш держава пактісі', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Тоғыз держава трактаты', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Бес держава трактаты', isCorrect: false),]),
    UBTQuestionModel(questionId: '10', question: 'Ресейдегі Ақпан революциясы нәтижесінде биліктен бас тартқан Романовтар әулетінің соңғы билеушісі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'III Александр', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'II Александр', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'I Николай', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'II Николай', isCorrect: true),]),
    UBTQuestionModel(questionId: '11', question: '1936 жылы ақпанда тиімді реформаларды ұсыну нәтижесінде Испанияда билікке келген топ:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Халықтық майдан', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Ұлтшыл блок', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Коммунистер', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Фашистер', isCorrect: false),]),
    UBTQuestionModel(questionId: '12', question: 'Италиядағы фашистік режімнің католик шіркеуінің қолдауына ие болуының себебі', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Фашистердің бір мезетте католик дінін қабылдауы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Фашистердің Ватикан мемлекетінің егемендегін мойындауы', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Фашистердің коалициялық үкімет құруға келісуі', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Фашистердің жүргізген демократиялық саясаты', isCorrect: false),]),
    UBTQuestionModel(questionId: '13', question: '1920-1930 жылдары КСРО дағы индустрияландыру саясатының негізінде салынған ірі кәсіпорын:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Сталинград трактор зауыты', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Өскемен қорғасын зауыты', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Тольяти автомобиль зауыты', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Павлодар трактор зауыты', isCorrect: false),]),
    UBTQuestionModel(questionId: '14', question: '1933 жылы Ұлттар лигасының Жапонияға айып тағы себебі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Қытайдағы басқыншылық әрекеттер', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Сахалин аралдарына басыр кіру', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Перл-Харборға жасаған шабуыл', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Үндіқытай түбіндегі агрессия', isCorrect: false),]),
    UBTQuestionModel(questionId: '15', question: '1943 жылы Екінші майдан ашу мәселесі қарастырылған конференция:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Мәскеу', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Тегеран', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Қырым', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Париж', isCorrect: false),]),
    UBTQuestionModel(questionId: '16', question: '1938 жылғы Мюнхен келісімінің Чехославакияның аумағына байланысты қабылдаған шешімі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Чехославакия аумағын төртке бөлу', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Судет облысын  Германияға беру', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Чехияға тәуелсіздік беру', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Чехияны Дунай бойымен бөлу', isCorrect: false),]),
    UBTQuestionModel(questionId: '17', question: '1968 жылы мамырда Францияда туындаған күрделі әлеуметтік-саяси дағдарыс туындаған себеп:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'радикалды студенттердің наразылығы', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'жалақының 25%-ға азаюы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'НАТО әскери құрылымының шығуы', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'ақылы еңбек демалысының 2 аптаға қысқартылуы', isCorrect: false),]),
    UBTQuestionModel(questionId: '18', question: '1963 жылы Кариб дағдарысын кейін атмосферада, ғарышта және су астында ядролық сынаққа тыйым салған шешім қабылданды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ялтада', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Тегеранда', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Парижде', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Мәскеуде', isCorrect: true),]),
    UBTQuestionModel(questionId: '19', question: '1983 жылы 10 жасар америкалық оқушы Саманта Смиттің КСРО ға келу сапары адамдардың назарын аударды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Экологиялық жасыл ортаны құру ісіне оқушыларды тартуға', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Жердегі бейбітшілікті сақтау мәселесіне', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Балаларға арналған демалыс, сауықтыру орындарын арттыруға', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Білім беру саласына бөлінетін қаржыны көбейтуге', isCorrect: false)]),
    UBTQuestionModel(questionId: '20', question: 'Еуропада елдердің соғыс зардаптарынан кейін экономикасын қалпына келтіруге көмек берген жоспары:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Барбаросса', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Тайфун', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Маршалл', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Трумэн', isCorrect: false),]),
    UBTQuestionModel(questionId: '21', question: 'КОНТЕКСТ\nТарихи білімдеріңізді пайдалана отырып, суретте көрсетілген тарихи тұлғаларды анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Пруссия корольдері', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Белгілі ағартушы монархтар', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Ресей патшалары', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Француз корольдері', isCorrect: false),],image: 'https://firebasestorage.googleapis.com/v0/b/history-app-777.appspot.com/o/worldHistory%2FScreenshot%202024-05-30%20at%2016.51.45.png?alt=media&token=e3300105-c7af-4b4d-b25f-c40e7afc1e8d'),
    UBTQuestionModel(questionId: '22', question: 'Тарихи білімдеріңізді пайдалана отырып, тарихи тұлғаларға қатысты оқиғаны анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'XVIII ғасырда мемлекетті басқарды', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'XVII ғасырда мемлекеттті басқарды', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Философ Вольтердің идеяларын қолдады', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Санкт-Петербург қаласының негізін қалады', isCorrect: false),]),
    UBTQuestionModel(questionId: '23', question: ' Тарихи білімдеріңізді пайдалана отырып,2-суретте көрсетілген тарихи тұлғаға дәйекті анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Жабық есік саясатын ұстанды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Әскери міндеткерлікті енгізді', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Жер иесіне шағымдануға тыйым салды', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Наштадт келісіміне қол жеткізді', isCorrect: true),]),
    UBTQuestionModel(questionId: '24', question: 'Тарихи білімдеріңізді пайдалана отырып, 1-суретте көрсетілген тұлғаның Ресей тарихында алатын орнын анықтаңыз:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Еуропада барған алғашқы орыс патшасы болды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Ағартушылық абсолютизм саясатын жүргізді', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Ману фактураларда жалдамалы жұмысшылар пайда болды', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Дворяндар үшін алтын кезең саясатын жасады', isCorrect: false),]),
    UBTQuestionModel(questionId: '25', question: 'Тарихи білімдеріңізді пайдалана отырып, 1 және 2 суреттегі тұлғалардың жасаған реформаларын анықтаңыз\nI.Еуропаға жол ащты\nII.Азаматтық, Коммерциялық, Қылмыстық кодекстер қабылдады\nIII. «Адам және азамат құқытарының» декларациясын қабылдады\nIV. Кәсіпкерлікке жағдай жасайтын заңдарды қабылдады\n', options: [
      UBTOptionModel(optionId: 'A',      answer: 'II,III', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'I,III', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'I,IV', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'III,IV', isCorrect: false),]),
    UBTQuestionModel(questionId: '26', question: 'XVII ғасырдың екінші жартысында Франция мемлекетінің корольға тиесілі болған билік:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'шартты түрде, билік парламент қолында болды', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'тек салық енгізумен шектелді', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'тек шіркеуді басқарды', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'сот', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'атқарушы', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'заң  шығарушы', isCorrect: true),]),
    UBTQuestionModel(questionId: '27', question: '1857-1859 жылдары Солтүстік Үндістанда отаршылдарға қарсы көтеріліс құрамында болды:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'кәсіпкерлер', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'үнділік сипайлар', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'қолөнершілер', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'жұмысшылар', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'тоқымашылар', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'шаруалар', isCorrect: true),]),
    UBTQuestionModel(questionId: '28', question: 'Наполеондық империяны бөліске салуда Вена конгресінде жетекші роль атқарған елдер:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Франция', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Италия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Австрия', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Испания', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Ресей', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Англия', isCorrect: true),]),
    UBTQuestionModel(questionId: '29', question: 'Қытайда «Үлкен секіріс» деп аталған реформаны жүзеге асырған тұлға:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ли Куан Ю', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Сунь Ятсен', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Дэн Сяопин', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Г.Танака', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Мао Цзэдун', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Чан Кайши', isCorrect: false),]),
    UBTQuestionModel(questionId: '30', question: '1900 жылы Қытайға интервенция бастаған державалар:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Испания', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Түркия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Корея', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Жапония', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'АҚШ', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Ресей', isCorrect: true),]),
    UBTQuestionModel(questionId: '31', question: 'Мемлекеттік құрылысы туралы жазған ежелгі грек философы:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Цезарь', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Цицерон', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Плебс', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Аристотель', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Вергилий', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Платон', isCorrect: true),]),
    UBTQuestionModel(questionId: '32', question: 'Римдегі Әулие Петр соборын салуға қатысқан қайта өрлеу дәуірінің өкілі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Джотто ди Бондоне', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Данте', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Леонарда да Винчи', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Донателло', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Томмазо Кампанелла', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Микеланджело', isCorrect: true),]),
    UBTQuestionModel(questionId: '33', question: 'Белгілі француз ағартушысы Монтескьенің «Заңдар рухы туралы» еңбегінде көрсетілген өкіметтің түрі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Автократия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Теократия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Конституциялық монархия', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Деспотизм', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Абсалюттік монархия', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Республика', isCorrect: true),]),
    UBTQuestionModel(questionId: '34', question: 'Бүкіл дүниежүзінде танылған Стив Джобстың IT-технологиялар дәуірінің бастаушысы ретінде енгізген бағдраламалары:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'iTunes', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'iMac', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Telegram', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'playmarket', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'iPhone', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'windows', isCorrect: false),]),
    UBTQuestionModel(questionId: '35', question: 'Дәстүрлі экономиканың кемшілігі:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'ұйымдастырудың қарапайым түрі', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'табиғи жағдайларға тәуелділік', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'халықтың еңбекпен қамтылуы', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'еңбек өнімдерілігінің төмен болуы, артық өнімнің болмауы', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'қарапайым технологиялар қол еңбегі', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'шаруашылықтың экологиялық түрі', isCorrect: false),]),
  ];


  final variant7 = <UBTQuestionModel>[
    UBTQuestionModel(questionId: '01', question: 'Үндістанда қалыптасқан ең ежелгі дін:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'иудаизм', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'синтоизм', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'зорастризм', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'будда', isCorrect: true),]),
    UBTQuestionModel(questionId: '02', question: 'ХІ ғасырда София соборы тұрғызылған орыс қаласы:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Киев', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Мәскеу', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Новгород', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Владмир', isCorrect: false),]),
    UBTQuestionModel(questionId: '03', question: '451 жылы Галлиядағы Аттиламен Еуропа одақтастарының арасындағы шайқас өткен жер атауы:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Неккар', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Панония', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Каталаун', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Толоз', isCorrect: false),]),
    UBTQuestionModel(questionId: '04', question: 'Испан тіліндегі «конкискадор» сөзінің мағынасы', options: [
      UBTOptionModel(optionId: 'A',      answer: 'қайтарушы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'жаулап алушы', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'азат етуші', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'саяхатшы', isCorrect: false),]),
    UBTQuestionModel(questionId: '05', question: '1866 жылы 23 тамызда қол қойылған Париждегі келісімшартына сәйкес, Герман одағынан біржола шыққан империя', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Дания', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Италия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Австрия', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Пруссия', isCorrect: false),]),
    UBTQuestionModel(questionId: '06', question: '«Қан мен темірдің саясатын» жүргізген канцлер', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Гарибальди', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Бисмарк', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'IV Вильгелм', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Мадзини', isCorrect: false),]),
    UBTQuestionModel(questionId: '07', question: 'ХІХ ғасырдың екінші жартысында Ұлыбританияда болған үстемдіктен айырыла бастаған тап', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Мұғалімдер, инженерлер, офицерлер', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Аристократия', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Орта тап', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Жұмысшылар', isCorrect: false),]),
    UBTQuestionModel(questionId: '08', question: '1861 жылы наурызда ІІ Виктор Эммануил король болып жарияланған мемлекет', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Австрия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Испания', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Италия', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Англия', isCorrect: false),]),
    UBTQuestionModel(questionId: '09', question: '1916 жылдары Сомма өзенінің бойында алғаш рет танкілерді қолданған мемлекет', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Болгария', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Англия', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Ресей', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Франция', isCorrect: false),]),
    UBTQuestionModel(questionId: '10', question: 'Антибольшевиктік қозғалыстың негізгі орталықтары', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Мурманск мен Владивосток', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Ростов пен Краснодар', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Қазан мен Орынбор', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Мәскеу мен Петроград', isCorrect: true),]),
    UBTQuestionModel(questionId: '11', question: '11.Версаль бейбіт келісімшарты бойынша Германия басшылығы тәуелсіздігін мойындаған елдерді анықтаңыз\n1.Австрия \n  2.Польша  \n  3.Англия   \n  4.Франция', options: [
      UBTOptionModel(optionId: 'A',      answer: '3, 4', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '1, 2', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: '2, 4', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '1, 3', isCorrect: false),]),
    UBTQuestionModel(questionId: '12', question: 'Синхай революциясының саясатына тән емес белгі', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ұлттық', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Социалистік', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Антиимпералистік', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Буржуазиялық', isCorrect: false),]),
    UBTQuestionModel(questionId: '13', question: 'И.Сталин жүргізген саясатқа қатысты оқиғалардың хронологиялық реттілігін анықтаңыз:\n1.Қайта құру\n2.Ұжымдастыру\n3.Индустрияландыру\n4.Жаппай қуғын-сүргін\n', options: [
      UBTOptionModel(optionId: 'A',      answer: '3, 2, 4,1', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: '2, 1, 3,4', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '2, 3, 4,1', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '1, 2, 4,3', isCorrect: false),]),
    UBTQuestionModel(questionId: '14', question: 'ХХ ғасырдың 30-жылдары Жапонияның ұстанған бағыты', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Авторитарлық жүйе', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Тоталитарлық жүйе', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Социалистік мемлекет құру', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Демократиялық жүйе', isCorrect: false),]),
    UBTQuestionModel(questionId: '15', question: '1939 жылы 23 наурызда герман-румын келісіміне қол қойған қала', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Бухарест', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Будапешт', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Клеэйпедя', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'София', isCorrect: false),]),
    UBTQuestionModel(questionId: '16', question: '1941 жылы 11 наурызда Ленд-лиз туралы заң қабылдаған мемлекет', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Германия', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'АҚШ', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Ұлыбритания', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'КСРО', isCorrect: false),]),
    UBTQuestionModel(questionId: '17', question: 'НАТО ға қатысты дұрыс дәйекті анықтаңыз/nІ. АҚШ пен Канаданың өзара келіссөздері негізінде құрылды/nІІ.Қытайға қарсы әрекетке бағытталды/nІІІ.Екінші дүниежүзілік соғыс басталғанда құрылд/nІV.Еуропаны АҚШ тың басып алуынан қорғану үшін құрылды/n', options: [
      UBTOptionModel(optionId: 'A',      answer: 'ІV', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'ІІІ', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'ІІ', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'І', isCorrect: true),]),
    UBTQuestionModel(questionId: '18', question: 'Биполярлы жүйесінің ыдырауынан кейін орын алған маңызды тарихи оқиға:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'КСРО ыдырауы', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Өзіндік сауда ұйымы құрылуы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Қайта құру саясатының басталуы', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Отар елдердің тәуелсіздікке қол жеткізуі', isCorrect: false),]),
    UBTQuestionModel(questionId: '19', question: 'Екінші дүниежүзілік соғыстан кейін орын алған тарихи оқиғаларға қатысты дұрыс дәйектерді анықтаңыз\nІ. 1945 жылы КСРО әлемдегі жалғыз ядролық держава болды /nІІ. «Қырғи қабақ соғыстың » бастамасы – У.Черчилльдің Фултондағы сөзі болды/nІІІ. Ядролық қаруға КСРО -ның монополиясы тек төрт жыл ғана сақталды/nІV.Корей соғысы-қырғиқабақ соғыс кезіндегі орын алған алғашқы әскери қақатығыс/nV.1945 жылы КСРО өзінің бірінші атом бомбасын сынақтан өткізді/n', options: [
      UBTOptionModel(optionId: 'A',      answer: 'ІІ, ІІІ', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'І, V', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'ІІ, ІV', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'І, ІІ', isCorrect: false)]),
    UBTQuestionModel(questionId: '20', question: '1947 жылы Франция үкіметі қабылдаған қайта құру жоспары', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Дауэс жоспары', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Шуман жоспары', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Маршалл жоспары', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Монне жоспары', isCorrect: true),]),
    UBTQuestionModel(questionId: '21', question: 'Контекст\nОтарсыздану кезеңдері\n«Отарсызданудың бірінші кезеңі (1943–1956 жж.), негізінен, Азия мен Солтүстік Африка елдерін қамтыды. Еуропалық елдер, соның ішінде Англия Палестина мен Иорданияны, ал Франция бол-са Ливан мен Сирияны басқару мандаттарынан бас тартты. Италия мен Жапония отарларының да тағдыры шешілді.Екінші кезеңде, 50–60-жылдардың соңында отарсыздану үдерісі Африканы қамтыды. 1956 жылы Француз үкіметі Марокко мен Тунистің тәуелсіздігін мойындады. Алжирді азат ету майданы көтерілісшілерімен 8 жылға созылған (1954–1962 жж.) соғыстан басталды.Үшінші кезеңде (70-ж.) ең көне отарлық империя – Португалия империясы құлатылды. 1973 жылы ұзақ жылдарға созылған қарулы күрестен соң алғашқылардың бірі болып Гвинея-Бисау тәуелсіздікке қол жеткізді. 1974 жылғы сәуір айындағы «қалампыр төңкерісінің» нәтижесінде Португалияда әскери диктатура құлатылған соң, португалиялық басқа отарлар да – Жасыл мүйіс аралдары, Ангола, Мозамбик, Сан-Томе мен Принсипи тәуелсіздіктерін алды.»Төртінші кезеңде (80–90-жж.) отарлық империялардағы соңғы иеліктер өз тәуелсіздіктерін алды. 1980 жылы Оңтүстік Родезия (Зимбабве) мәселесі түпкілікті шешілді. 1982 жылы Англия Белизге тәуелсіздік берді. 1990 жылы әлемдік қауымдастықтың қысымымен Оңтүстік Африка Республикасы Намибияның тәуелсіздігін таны-ды. 1997 жылы Қытай Ұлыбританиядан Гонконгті, 1999 жылы Португалиядан Макаоны қайтарып алды.\nМәнмәтінді  пайдаланып, отарсыздану үдерісіне қатысты төрт кезеңге де ортақ факторды  анықтаңыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ортақ әскери диктатураға бағыну', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Бір партиялық жүйенің қалыптасуы', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Ұлт азаттық қозғалыстар', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Сауда келісімдерін жасау', isCorrect: false),]),
    UBTQuestionModel(questionId: '22', question: 'Мәнмәтін және тарихи білімдеріңізді пайдаланып, отары бар елдердің атауын анықтаңыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Доминон', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Автономия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Метрополия', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Фактория', isCorrect: false),]),
    UBTQuestionModel(questionId: '23', question: 'Мәнмәтін және тарихи білімдеріңізді пайдаланып, Африка және Азияда ең көп отарға ие болған мемлекеттерді анықтаңыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'АҚШ, Испания', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Португалия, Германия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Ұлыбритания, Франция', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Италия, Жапония', isCorrect: false),]),
    UBTQuestionModel(questionId: '24', question: 'Мәнмәтін  және тарихи білімдеріңізді пайдаланып, 1974 жылы болған «қалампыр төңкерісінің нәтижесін» анықтаңыз', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Бірпартиялық жүйе қалыпттасты', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Әскери диктатура орнады', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Әскери диктатура құлатылды', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Социалистік даму жолын таңдады', isCorrect: false),]),
    UBTQuestionModel(questionId: '25', question: 'Мәнмәтінді пайдалана отырып, отарсыздану үдерісіне қатысты дұрыс дәйектерді анықтаңыз\nІ. «Африка жылы» деп аталған бетбұрысты кезең болды\nІІ. Жасыл мүйіс аралдары, Ангола, Мозамбик, Сан-Томе ағылшындардан тәуелсіздігін алды\nІІІ. Гвинея-Бисау португалдықтардан тәуелсіздігін алды\nІV. Ұлыбритания Камбоджа мен Лаостың тәуелсіздігін мойындады\nV.Оңтүстік Африка Республикасы Намбияның тәуелсіздігін мойындады\n', options: [
      UBTOptionModel(optionId: 'A',      answer: 'II, III,V', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'I, II, IV', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'I, III, V', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'I, II, III', isCorrect: false),]),
    UBTQuestionModel(questionId: '26', question: 'ХІХ ғасырдың екінші жартысындағы Италиядағы көтеріліс басшысы(-лар):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Франц Иосиф', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Бенито Муссолини', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Камилло Бенсо-Кавур', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Джузеппе Гарибальди', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Виктор Эммануил', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Джузеппе Верди', isCorrect: false),]),
    UBTQuestionModel(questionId: '27', question: 'XIX ғ. ортасында ұлы державалвр қатарына кірген мемлекет(-тер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Испания', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Пруссия', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Италия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Ломбардия', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Сербия', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Сицилия', isCorrect: false),]),
    UBTQuestionModel(questionId: '28', question: 'XIX ғасырда Ресейде ашылған жасырын «Құтқару одағы» қоғамының негзгі мүшесі(-лері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Н.И.Тургенов', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'П.И.Пестель', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'П.Л.Лавров', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'А.Н.Радищев', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Н.М.Муравьев', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'П.Н.Ткачев', isCorrect: false),]),
    UBTQuestionModel(questionId: '29', question: '1813 жылы бекітілген «Гүлстан» келісіміне сай Иранның айырылып қалған жері(-лері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Ауғанстан', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Абхазия', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Ирак', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Грузия', isCorrect: true),
      UBTOptionModel(optionId: 'E',      answer: 'Қырым', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Дағыстан', isCorrect: true),]),
    UBTQuestionModel(questionId: '30', question: 'Оңтүстік Кореяның ұлттық және экономикалық дамудың үлгісі ретінде таңдап алған елі(-дері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'КСРО', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Үндістан', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Қытай', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Филиппин', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Түркия', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Жапония', isCorrect: true),]),
    UBTQuestionModel(questionId: '31', question: 'Аристотельдің ғылымды жүйелеген бағыттары:', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Практикалық', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Поэтикалық', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Теоретикалық', isCorrect: true),
      UBTOptionModel(optionId: 'D',      answer: 'Гуманитарлық', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Философиялық', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Этикалық', isCorrect: false),]),
    UBTQuestionModel(questionId: '32', question: 'Араб тарихшысы және географы әл-Масуди еңбегі(-тері):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Замана тарихы', isCorrect: true),
      UBTOptionModel(optionId: 'B',      answer: 'Масғұд кестелері', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Мейірімді қала тұрғындары', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Замана тарихы', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Мың бір түн', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: 'Күн қаласы', isCorrect: false),]),
    UBTQuestionModel(questionId: '33', question: '1970-1990 жылдары білім беру саласында жетекші елдер қатарына қосылған жаңа индустралды мемлекет(-тер):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Солтүстік Корея', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Сирия', isCorrect: true),
      UBTOptionModel(optionId: 'C',      answer: 'Индонезия', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Оңтүстік Корея', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Сингапур', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Малайзия', isCorrect: true),]),
    UBTQuestionModel(questionId: '34', question: 'Ұлыбританияда құрылған Нобель бейбітшілік сыйлығын алған, халықаралық үкіметтік емес ұйым(-дар):', options: [
      UBTOptionModel(optionId: 'A',      answer: 'Қызыл ай қоғамы', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: 'Гринпис', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: 'Халықаралық құқық ассоциациясы', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: 'Тәуелсіз журналистер', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: 'Халықаралық амнистия', isCorrect: true),
      UBTOptionModel(optionId: 'F',      answer: 'Шегарасыз дәрігерлер', isCorrect: false),]),

  ];











  final variantZZ = <UBTQuestionModel>[
    UBTQuestionModel(questionId: '01', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '02', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '03', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '04', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '05', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '06', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '07', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '08', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '09', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '10', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '11', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '12', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '13', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '14', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '15', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '16', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '17', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '18', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '19', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'G', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'H', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '20', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'G', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'H', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '21', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'G', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'H', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '22', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'G', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'H', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '23', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'G', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'H', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '24', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'G', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'H', answer: '', isCorrect: false),
    ]),
    UBTQuestionModel(questionId: '25', question: '', options: [
      UBTOptionModel(optionId: 'A', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'G', answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'H', answer: '', isCorrect: false),
    ]),
  ];


  final variantZZZ = <UBTQuestionModel>[
    UBTQuestionModel(questionId: '01', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '02', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '03', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '04', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '05', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '06', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '07', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '08', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '09', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '10', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '11', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '12', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '13', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '14', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '15', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '16', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '17', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '18', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '19', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false)]),
    UBTQuestionModel(questionId: '20', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '21', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '22', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '23', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '24', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '25', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '26', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '27', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '28', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '29', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '30', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '31', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '32', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '33', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '34', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '', isCorrect: false),]),
    UBTQuestionModel(questionId: '35', question: '', options: [
      UBTOptionModel(optionId: 'A',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'B',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'C',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'D',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'E',      answer: '', isCorrect: false),
      UBTOptionModel(optionId: 'F',      answer: '', isCorrect: false),]),
  ];
}
