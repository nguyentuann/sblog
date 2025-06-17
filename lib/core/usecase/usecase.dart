abstract class Usecase<Type, Params> { // Type: kiểu trả về, Params: kiểu tham số đầu vào
  Future<Type> call({required Params params});
}