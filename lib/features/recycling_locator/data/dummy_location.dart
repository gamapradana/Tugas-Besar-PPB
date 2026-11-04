import '../models/recycling_location.dart';

const List<RecyclingLocation> dummyLocation = [
  RecyclingLocation(
    name: 'Bank Sampah BojongSantos', 
    address: 'Jl. Sukapura, bandung', 
    category: 'Plastik, kertas, kardus', 
    distance: '2.3 km', 
    isOpen: true,
    description: 
      'Bank sampah ini menerima jenis sampah daur ulang seperti plastik, kertas dan kardus'
    ),
  RecyclingLocation(
    name: 'Telu recycling center', 
    address: 'Jl. Telekomunikasi, bandung', 
    category: 'Plastik, elektronik', 
    distance: '1.1 km', 
    isOpen: false,
    description: 
      'Bank sampah ini hanya menerima jenis sampah daur ulang seperti plastik dan elektronik'
    ),
    RecyclingLocation(
    name: 'Bank sampah Kotaku ', 
    address: 'Jl. Sukabirus, bandung', 
    category: 'Plastik, kertas, kardus', 
    distance: '3.4 km', 
    isOpen: true,
    description: 
      'Bank sampah ini menerima jenis sampah daur ulang seperti plastik, kertas dan kardus'
    ),  
];