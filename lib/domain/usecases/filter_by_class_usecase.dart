import '../../data/repositories/student_repository.dart';
import '../../data/models/student.dart';

class FilterByClassUsecase {
  final StudentRepository studentRepo;

  FilterByClassUsecase(this.studentRepo);

  Future<List<Student>> filter({int? classId}) {
    return studentRepo.getAll(classId: classId);
  }
}
