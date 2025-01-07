class SelectService {
  static Map<String, dynamic>? _selectedService;

  // Method to select a service
  static void selectService(Map<String, dynamic> service) {
    _selectedService = service;
  }

  // Method to get the selected service
  static Map<String, dynamic>? getSelectedService(service) {
    return _selectedService;
  }
}
