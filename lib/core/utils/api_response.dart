class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;

  ApiResponse({
    this.data,
    this.error,
    required this.success,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(
      data: data,
      success: true,
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse(
      error: message,
      success: false,
    );
  }
} 