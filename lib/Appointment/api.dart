import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentApiService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getBranches() async {
    final response = await _supabase.from('hospitalbranch').select('id, name');
    return (response as List)
        .map((e) => {'id': e['id'], 'name': e['name']})
        .toList();
  }

  Future<List<Map<String, dynamic>>> getSpecializations(
      String branchName) async {
    final branchRes = await _supabase
        .from('hospitalbranch')
        .select('id')
        .eq('name', branchName)
        .single();
    if (branchRes == null || branchRes['id'] == null) {
      return [];
    }
    final branchId = branchRes['id'];
    final scheduleRes = await _supabase
        .from('schedule')
        .select('specialization_id')
        .eq('hospital_branch_id', branchId);
    final specIds = (scheduleRes as List)
        .map((e) => e['specialization_id'])
        .toSet()
        .toList();
    if (specIds.isEmpty) return [];
    final specRes = await _supabase
        .from('specialization')
        .select('name,id')
        .inFilter('id', specIds);
    return (specRes as List)
        .map((e) => {'id': e['id'], 'name': e['name']})
        .toList();
  }

  Future<List<String>> getDays(int branchId, int specializationId) async {
    final response = await _supabase
        .from('schedule')
        .select('day_of_week')
        .eq('hospital_branch_id', branchId)
        .eq('specialization_id', specializationId);
    return (response as List).map((e) => e['day_of_week'].toString()).toList();
  }

  Future<List<String>> getTimeSlots(
      int branchId, int specializationId, String day) async {
    final scheduleId = await _supabase
        .from('schedule')
        .select('id')
        .eq('hospital_branch_id', branchId)
        .eq('specialization_id', specializationId)
        .eq('day_of_week', day)
        .single();
    final response = await _supabase
        .from('timeslot')
        .select('start_time')
        .eq('schedule_id', scheduleId['id']);
    return (response as List).map((e) => e['start_time'].toString()).toList();
  }

  Future<List<Map<String, dynamic>>> getDoctors(int specializationId) async {
    final response = await _supabase
        .from('doctors')
        .select('id, name, photo_url')
        .eq('specialization_id', specializationId);
    return (response as List)
        .map((e) => {
              'id': e['id'],
              'name': e['name'],
              'photo_url': e['photo_url'],
            })
        .toList();
  }
}
