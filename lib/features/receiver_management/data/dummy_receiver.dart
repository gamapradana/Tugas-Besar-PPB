import '../models/receiver_location.dart';

final List<ReceiverLocation> dummyReceivers = [
  ReceiverLocation(
    name: 'Bank Sampah Maju Jaya',
    description: 'Tempat pengumpulan dan pengelolaan sampah daur ulang.',
    address: 'Jl.Bojongsantos no 45, Bandung',
    phone: '081234567890',
    operatingHours: '08.00 - 16.00',
    acceptedCategories: [
      'Plastik',
      'Kertas',
      'Kardus',
      'Logam',
    ],
    status: 'Active',
    isActive: true,
  ),
  ReceiverLocation(
    name: 'Recycle Center Bandung',
    description: 'Pusat penerimaan sampah plastik dan elektronik.',
    address: 'Jl. teddybrown no 12, Bandung',
    phone: '081298765432',
    operatingHours: '09.00 - 17.00',
    acceptedCategories: [
      'Plastik',
      'Elektronik',
    ],
    status: 'Pending',
    isActive: true,
  ),
  ReceiverLocation(
    name: 'Daur Ulang Mandiri',
    description: 'Tempat penerimaan berbagai material yang dapat didaur ulang.',
    address: 'Jl. jawa No. 5, Cimahi',
    phone: '082112345678',
    operatingHours: '08.00 - 15.00',
    acceptedCategories: [
      'Kertas',
      'Kardus',
      'Logam',
    ],
    status: 'Rejected',
    isActive: false,
  ),
];
