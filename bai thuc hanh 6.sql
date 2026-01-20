insert into patients (full_name, phone, city, symptoms) values
('nguyen van an','0900000001','ha noi', array['sot','ho']),
('tran thi binh','0900000002','ho chi minh', array['dau dau','mat ngu']),
('le van cuong','0900000003','da nang', array['dau bung','tieu chay']),
('pham thi dung','0900000004','ha noi', array['ho','kho tho']),
('vo van em','0900000005','can tho', array['dau hong','sot']);

insert into doctors (full_name, department) values
('bs nguyen minh','noi'),
('bs tran lan','ngoai'),
('bs le hung','nhi'),
('bs pham quang','da lieu'),
('bs vo anh','mat');

insert into appointments (patient_id, doctor_id, appointment_date, diagnosis, fee) values
(1,1,'2024-08-01','cam cum',150.00),
(1,2,'2024-08-10','kiem tra tong quat',300.00),
(2,2,'2024-08-02','dau bung',200.00),
(2,3,'2024-08-11','tieu hoa',250.00),
(3,1,'2024-08-03','roi loan tieu hoa',180.00),
(3,4,'2024-08-12','di ung da',220.00),
(4,3,'2024-08-04','viem hong',160.00),
(4,5,'2024-08-13','kham mat',400.00),
(5,4,'2024-08-05','man do',210.00),
(5,1,'2024-08-14','sot sieu vi',190.00);

create index idx_patients_phone
on patients (phone);

create index idx_patients_city_hash
on patients using hash (city);

create index idx_patients_symptoms_gin
on patients using gin (symptoms);

create extension if not exists btree_gist;

create index idx_appointments_fee_gist
on appointments using gist (fee);

create index idx_appointments_date
on appointments (appointment_date);

cluster appointments using idx_appointments_date;

create view v_top_patients_fee as
select p.patient_id, p.full_name, sum(a.fee) as total_fee
from patients p
join appointments a on a.patient_id = p.patient_id
group by p.patient_id, p.full_name
order by total_fee desc;

select * from v_top_patients_fee limit 3;

create view v_total_visits_by_doctor as
select d.doctor_id, d.full_name, count(a.appointment_id) as total_visits
from doctors d
left join appointments a on a.doctor_id = d.doctor_id
group by d.doctor_id, d.full_name
order by total_visits desc;

select * from v_total_visits_by_doctor;

create view v_patient_city as
select patient_id, full_name, city
from patients
with check option;

update v_patient_city
set city = 'hai phong'
where patient_id = 1;

select * from patients where patient_id = 1;
