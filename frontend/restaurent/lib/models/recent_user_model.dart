class RecentUser {
  final String? icon, name, phoneNumber, reservationDate, reservationTime,  email, status;
  final int? numberOfPeople;

  RecentUser({
    this.icon,
    this.name,
    this.phoneNumber,
    this.reservationDate,
    this.reservationTime,
   
    this.numberOfPeople,
    this.email,
    this.status,
  });
}
List<RecentUser> recentUsers = [
  RecentUser(
    icon: "../../assets/icons/xd_file.svg",
    name: "Deniz Çolak",
    phoneNumber: "123-456-7890",
    numberOfPeople: 4,
    reservationDate: "01-03-2021",
    reservationTime: "7:00 PM",
   
    email: "deniz@example.com",
    status: "Confirmed",
  ),
  RecentUser(
    icon: "../../assets/icons/Figma_file.svg",
    name: "S*** Ç****",
    phoneNumber: "098-765-4321",
    numberOfPeople: 2,
    reservationDate: "27-02-2021",
    reservationTime: "8:00 PM",

    email: "s@example.com",
    status: "Pending",
  ),
  RecentUser(
    icon: "../../assets/icons/doc_file.svg",
    name: "N***** D****",
    phoneNumber: "123-123-1234",
    numberOfPeople: 5,
    reservationDate: "23-02-2021",
    reservationTime: "6:00 PM",

    email: "n@example.com",
    status: "Cancelled",
  ),
  RecentUser(
    icon: "../../assets/icons/sound_file.svg",
    name: "B***** K****",
    phoneNumber: "456-456-4567",
    numberOfPeople: 3,
    reservationDate: "21-02-2021",
    reservationTime: "9:00 PM",
 
    email: "b@example.com",
    status: "Confirmed",
  ),
  RecentUser(
    icon: "../../assets/icons/media_file.svg",
    name: "A**** S**** K****",
    phoneNumber: "789-789-7890",
    numberOfPeople: 6,
    reservationDate: "23-02-2021",
    reservationTime: "5:00 PM",
  
    email: "a@example.com",
    status: "Pending",
  ),
  RecentUser(
    icon: "../../assets/icons/pdf_file.svg",
    name: "T***** S****",
    phoneNumber: "101-101-1010",
    numberOfPeople: 1,
    reservationDate: "25-02-2021",
    reservationTime: "7:30 PM",
   
    email: "t@example.com",
    status: "Confirmed",
  ),
  RecentUser(
    icon: "../../assets/icons/excle_file.svg",
    name: "K***** D****",
    phoneNumber: "202-202-2020",
    numberOfPeople: 4,
    reservationDate: "25-02-2021",
    reservationTime: "8:30 PM",
   
    email: "k@example.com",
    status: "Cancelled",
  ),
];
