-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 02, 2023 at 10:48 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rumah_sakit`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pasien` (IN `p_id` INT(8), IN `p_name` VARCHAR(30), IN `p_tanggal` DATE, IN `p_gender` CHAR(1), IN `p_alamat` VARCHAR(30), IN `p_periksa` DECIMAL(10,0))   BEGIN
insert into pasien(id_pasien,nama, tgl_lahir, gender,alamat,periksa) values (p_id,p_name, p_tanggal,p_gender, p_alamat,p_periksa);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_nama_jakarta` ()   BEGIN

 DECLARE finished int default 0;

 DECLARE nama_list varchar(500) default "";
 
 DECLARE nama_p varchar(50) default "";
 
 DECLARE user_data CURSOR FOR SELECT nama from pasien WHERE alamat="Jakarta";
 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
 
 OPEN user_data;
 
 get_user_nama: LOOP
 
 FETCH user_data INTO nama_p;
 
 IF finished = 1 THEN
 
  LEAVE get_user_nama;
 
 END IF;
 
 SET nama_list = CONCAT(nama_list,",",nama_p);
 
 END LOOP get_user_nama;
 
 CLOSE user_data;
 
 SELECT nama_list;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `hapus_pasien` (`i_nama` VARCHAR(30)) RETURNS INT(11)  BEGIN
    DECLARE deletedpasien VARCHAR(50);
    DELETE FROM pasien
    WHERE nama = i_nama;
    RETURN deletedpasien;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `insert_pasien` (`t_nama` VARCHAR(30), `t_tgl_lahir` DATE, `t_gender` CHAR(1), `t_alamat` VARCHAR(30), `t_periksa` DECIMAL(10,0)) RETURNS INT(11)  BEGIN
    DECLARE new_id INT;
    INSERT INTO pasien (nama, tgl_lahir, gender, periksa)
    VALUES (t_nama, t_tgl_lahir, t_gender, t_alamat,
    t_periksa);
    SET new_id = LAST_INSERT_ID();
    RETURN new_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `dokter`
--

CREATE TABLE `dokter` (
  `kd_dokter` char(5) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `gender` char(1) DEFAULT NULL CHECK (`gender` = 'L' or `gender` = 'P'),
  `alamat` varchar(30) DEFAULT NULL,
  `gaji` decimal(10,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dokter`
--

INSERT INTO `dokter` (`kd_dokter`, `nama`, `gender`, `alamat`, `gaji`) VALUES
('D0001', 'Ema Utami', 'P', 'Yogyakarta', '2500000'),
('D0002', 'Suwanto Suharjo', 'L', 'Jakarta', '2000000'),
('D0003', 'Ema Susanti', 'P', 'Semarang', '1500000'),
('D0004', 'Andi Sunyoto', 'L', 'Bandung', '2000000'),
('D0005', 'Emha Taufik Luthfi', 'L', 'Yogyakarta', '3000000');

-- --------------------------------------------------------

--
-- Table structure for table `jadwal_dokter`
--

CREATE TABLE `jadwal_dokter` (
  `kd_jadwal` char(5) NOT NULL,
  `hari` varchar(10) DEFAULT NULL CHECK (`hari` in ('Senin','Selasa','Rabu','Kamis','Jumat','Sabtu','Minggu')),
  `shift` varchar(10) DEFAULT NULL CHECK (`shift` = 'pagi' or `shift` = 'sore'),
  `kd_dokter` char(5) DEFAULT NULL,
  `jam_operasional` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jadwal_dokter`
--

INSERT INTO `jadwal_dokter` (`kd_jadwal`, `hari`, `shift`, `kd_dokter`, `jam_operasional`) VALUES
('A0001', 'Senin', 'Pagi', 'D0001', '07:00:00'),
('A0002', 'Senin', 'sore', 'D0002', '15:00:00'),
('B0002', 'Selasa', 'Sore', 'D0003', '15:00:00'),
('C0002', 'Rabu', 'Sore', 'D0005', '15:00:00'),
('D0001', 'Kamis', 'Pagi', 'D0001', '07:00:00'),
('D0002', 'Kamis', 'Sore', 'D0002', '15:00:00'),
('E0001', 'Jumat', 'Pagi', 'D0003', '07:00:00'),
('E0002', 'Jumat', 'Sore', 'D0005', '15:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `log_trigger`
--

CREATE TABLE `log_trigger` (
  `id` int(11) NOT NULL,
  `kejadian` varchar(50) NOT NULL,
  `waktu` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `obat`
--

CREATE TABLE `obat` (
  `kd_obat` char(5) NOT NULL,
  `obat` varchar(100) NOT NULL,
  `efek_samping` varchar(255) DEFAULT NULL,
  `expired` date DEFAULT NULL,
  `tanggal_produksi` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `obat`
--

INSERT INTO `obat` (`kd_obat`, `obat`, `efek_samping`, `expired`, `tanggal_produksi`) VALUES
('OBT01', 'Paracetamol', 'Mual, muntah', '2023-12-31', '2022-06-15'),
('OBT02', 'Ketoconazole ', 'Mual dan muntah, Pusing, Sakit kepala, Sakit perut, diare', '2024-09-30', '2022-08-20'),
('OBT03', 'Microlax', 'Mual, perut kembung', '2024-12-31', '2023-01-15'),
('OBT04', 'Kalpanax', 'Iritasi kulit, seperti kemerahan, sensasi terbakar dan gatal', '2023-09-30', '2022-07-10'),
('OBT05', 'Amoxicillin', 'Diare, alergi', '2023-10-31', '2022-12-05'),
('OBT06', 'Omeprazole', 'Mual, sakit perut', '2024-05-31', '2023-02-20'),
('OBT07', 'Super Tetra', ' Sakit kepala atau pusing, Mual atau muntah', '2023-11-16', '2023-06-27');

-- --------------------------------------------------------

--
-- Table structure for table `pasien`
--

CREATE TABLE `pasien` (
  `id_pasien` int(8) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `tgl_lahir` date DEFAULT NULL,
  `gender` char(1) DEFAULT NULL CHECK (`gender` = 'L' or `gender` = 'P'),
  `alamat` varchar(30) DEFAULT NULL,
  `periksa` decimal(10,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pasien`
--

INSERT INTO `pasien` (`id_pasien`, `nama`, `tgl_lahir`, `gender`, `alamat`, `periksa`) VALUES
(0, 'ega', '0000-00-00', 'l', 'karawang', '1'),
(1, 'Risa', '1997-10-12', 'P', 'Jakarta', '1'),
(2, 'Janu', '1996-02-10', 'L', 'Jakarta', '2'),
(3, 'Reva', '2000-11-30', 'P', 'Jakarta', '4'),
(4, 'Didi', '1989-01-20', 'L', 'Jakarta', '3'),
(5, 'Latifa', '1999-04-14', 'P', 'Jakarta', '1'),
(6, 'fahrul', '2003-07-12', 'L', 'jogja', '4'),
(7, 'VERDIAN', '2003-03-03', 'L', 'Yogyakarta', '2'),
(8, 'fuguh', '2023-07-01', 'L', 'notoyudan', '1'),
(9, 'Ega', '2003-05-12', 'L', 'Bobojong', '9'),
(10, 'ega', '0000-00-00', 'l', 'karawang', '1'),
(11, 'sadsa', '2023-07-20', 'P', 'dasda', '3'),
(12, 'ega', '2003-04-12', 'l', 'karawang', '1'),
(13, 'ega', '2003-04-12', 'l', 'karawang', '1');

-- --------------------------------------------------------

--
-- Table structure for table `penyakit`
--

CREATE TABLE `penyakit` (
  `kd_penyakit` char(5) NOT NULL,
  `penyakit` varchar(30) NOT NULL,
  `gejala` varchar(30) NOT NULL,
  `jenis_penyakit` varchar(10) NOT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penyakit`
--

INSERT INTO `penyakit` (`kd_penyakit`, `penyakit`, `gejala`, `jenis_penyakit`, `deskripsi`) VALUES
('K0001', 'Demam', 'Batuk & Pusing', 'Tidak menu', 'Demam terajadi pada suhu > 37, 2°C, biasanya disebabkan oleh infeksi'),
('K0002', 'Panu', 'Bercak kulit yang lebih terang', 'Tidak menu', ' Infeksi jamur pada kulit yang disebabkan oleh golongan jamur Malassezia'),
('K0003', 'Kadas', 'Ruam merah berbentuk lingkaran', 'Menular', 'Ruam yang disebabkan oleh infeksi jamur'),
('K0004', 'Kurap', 'Bersisik dan mungkin merah dan', 'Menular', 'Infeksi jamur pada kulit yang menimbulkan ruam melingkar berwarna merah'),
('K0005', 'Konstipasi', 'Tinja yang padat atau keras', 'Tidak menu', 'Kondisi sulit buang air besar'),
('K0006', 'Sifilis', 'Luka tanpa rasa sakit pada ala', 'Menular', 'Infeksi bakteri yang biasanya menyebar melalui kontak seksual dan dimulai dengan luka tanpa rasa sakit'),
('K0007', 'Demam dengue', 'Demam tinggi, sakit kepala, ny', 'Tidak menu', 'Virus yang dibawa oleh nyamuk');

-- --------------------------------------------------------

--
-- Table structure for table `resep`
--

CREATE TABLE `resep` (
  `kd_resep` char(5) NOT NULL,
  `hari` varchar(10) DEFAULT NULL CHECK (`hari` in ('senin','selasa','rabu','kamis','jumat','sabtu')),
  `tanggal` date DEFAULT NULL,
  `id_pasien` int(8) NOT NULL,
  `kd_penyakit` char(5) DEFAULT NULL,
  `kd_obat` char(5) DEFAULT NULL,
  `kd_dokter` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `resep`
--

INSERT INTO `resep` (`kd_resep`, `hari`, `tanggal`, `id_pasien`, `kd_penyakit`, `kd_obat`, `kd_dokter`) VALUES
('RE001', 'senin', '2015-02-15', 1, 'K0001', 'OBT01', 'D0001'),
('RE002', 'selasa', '2015-02-15', 2, 'K0002', 'OBT02', 'D0002'),
('RE003', 'rabu', '2023-07-05', 1, 'K0001', 'OBT01', 'D0003'),
('RE004', 'kamis', '2023-07-06', 5, 'K0007', 'OBT01', 'D0005'),
('RE005', 'kamis', '2023-07-06', 5, 'K0002', 'OBT02', 'D0005'),
('RE006', 'jumat', '2023-03-06', 2, 'K0003', 'OBT04', 'D0002'),
('RE007', 'selasa', '2023-04-06', 5, 'K0007', 'OBT01', 'D0003'),
('RE008', 'rabu', '2023-03-03', 2, 'K0007', 'OBT01', 'D0005'),
('RE009', 'senin', '2020-10-10', 3, 'K0005', 'OBT03', 'D0001'),
('RE010', 'selasa', '2019-12-06', 4, 'K0007', 'OBT01', 'D0001'),
('RE011', 'jumat', '2023-08-14', 6, 'K0006', 'OBT07', 'D0004');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `dokter`
--
ALTER TABLE `dokter`
  ADD PRIMARY KEY (`kd_dokter`);

--
-- Indexes for table `jadwal_dokter`
--
ALTER TABLE `jadwal_dokter`
  ADD PRIMARY KEY (`kd_jadwal`),
  ADD KEY `kd_dokter` (`kd_dokter`);

--
-- Indexes for table `log_trigger`
--
ALTER TABLE `log_trigger`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `obat`
--
ALTER TABLE `obat`
  ADD PRIMARY KEY (`kd_obat`);

--
-- Indexes for table `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`id_pasien`);

--
-- Indexes for table `penyakit`
--
ALTER TABLE `penyakit`
  ADD PRIMARY KEY (`kd_penyakit`);

--
-- Indexes for table `resep`
--
ALTER TABLE `resep`
  ADD PRIMARY KEY (`kd_resep`),
  ADD UNIQUE KEY `index_unique_resep` (`kd_resep`),
  ADD KEY `kd_penyakit` (`kd_penyakit`),
  ADD KEY `kd_obat` (`kd_obat`),
  ADD KEY `kd_dokter` (`kd_dokter`),
  ADD KEY `resep_ibfk_1` (`id_pasien`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `log_trigger`
--
ALTER TABLE `log_trigger`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `jadwal_dokter`
--
ALTER TABLE `jadwal_dokter`
  ADD CONSTRAINT `kd_dokter` FOREIGN KEY (`kd_dokter`) REFERENCES `dokter` (`kd_dokter`);

--
-- Constraints for table `resep`
--
ALTER TABLE `resep`
  ADD CONSTRAINT `resep_ibfk_1` FOREIGN KEY (`id_pasien`) REFERENCES `pasien` (`id_pasien`),
  ADD CONSTRAINT `resep_ibfk_2` FOREIGN KEY (`kd_penyakit`) REFERENCES `penyakit` (`kd_penyakit`),
  ADD CONSTRAINT `resep_ibfk_3` FOREIGN KEY (`kd_obat`) REFERENCES `obat` (`kd_obat`),
  ADD CONSTRAINT `resep_ibfk_4` FOREIGN KEY (`kd_dokter`) REFERENCES `dokter` (`kd_dokter`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
