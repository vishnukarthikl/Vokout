# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
owner = Owner.create({name: 'vishnu', email: 'foo@bar.com', password: '123456'})

facility = owner.create_facility({name: 'ABC fitness', address: 'peelamedu', phone: '123456789'})

m1 = facility.memberships.create({name: 'Monthly', duration: 1, cost: 1000})
m2 = facility.memberships.create({name: 'Half yearly', duration: 6, cost: 5500})
m3 = facility.memberships.create({name: 'Yearly', duration: 12, cost: 10000})

member1 = facility.members.create({name: 'Karthik', phone_number: '9876868672', email: 'ka@bar.com', is_male: true, date_of_birth: '25/10/1990', occupation: 'student', address: 'peelamedu', pincode: '641004', emergency_number: '9672846478'})
member1.subscriptions << Subscription.create({start_date: Date.today, membership: m1})

member2 = facility.members.create({name: 'Vijay', phone_number: '9123548672', email: 'vij@bar.com', is_male: true, date_of_birth: '03/01/1991', occupation: 'IT', address: 'rs puram', pincode: '641024', emergency_number: '9672846478'})
member2.subscriptions << Subscription.create({start_date: Date.today-40.days, membership: m2})

member3 = facility.members.create({name: 'Kumar', phone_number: '7722344672', email: 'kumar@bar.com', is_male: true, date_of_birth: '13/03/1991', occupation: 'student', address: 'race course', pincode: '641009', emergency_number: '9672846478'})
member3.subscriptions << Subscription.create({start_date: Date.today, membership: m3})

member4 = facility.members.create({name: 'Akshay', phone_number: '8932634465', email: 'akshay@bar.com', is_male: true, date_of_birth: '13/06/1989', occupation: 'Entrepreneur', address: 'gandhipuram', pincode: '641045', emergency_number: '9672855555'})
member4.subscriptions << Subscription.create({start_date: Date.today-36.days, membership: m2})

member5 = facility.members.create({name: 'Bharath', phone_number: '7722366666', email: 'bharath@bar.com', is_male: true, date_of_birth: '23/03/1995', occupation: 'student', address: 'erode', pincode: '641001', emergency_number: '9672866666'})
member5.subscriptions << Subscription.create({start_date: Date.today-16.days, membership: m1})

member6 = facility.members.create({name: 'Catherine', phone_number: '7728888888', email: 'catherine@bar.com', is_male: false, date_of_birth: '13/03/1992', occupation: 'student', address: 'peelamedu', pincode: '641023', emergency_number: '9999846478'})
member6.subscriptions << Subscription.create({start_date: Date.today-75.days, membership: m3})

member7 = facility.members.create({name: 'Dhivya', phone_number: '7722367890', email: 'dhivya@bar.com', is_male: false, date_of_birth: '13/03/1987', occupation: 'housewife', address: 'rspuram', pincode: '641002', emergency_number: '9675555478'})
member7.subscriptions << Subscription.create({start_date: Date.today-29.days, membership: m1})

member8 = facility.members.create({name: 'Eshwar', phone_number: '7754321672', email: 'eshwar@bar.com', is_male: true, date_of_birth: '13/07/1964', occupation: 'government employee', address: 'saravanampatti', pincode: '641035', emergency_number: '8765446478'})
member8.subscriptions << Subscription.create({start_date: Date.today-8.days, membership: m2})

member9 = facility.members.create({name: 'fathima', phone_number: '7722389654', email: 'fathima@bar.com', is_male: false, date_of_birth: '13/03/1984', occupation: 'entrepreneur', address: 'Trichy road', pincode: '641023', emergency_number: '9672888453'})
member9.subscriptions << Subscription.create({start_date: Date.today-143.days, membership: m3})

member10 = facility.members.create({name: 'Gambir', phone_number: '7723444672', email: 'gambir@bar.com', is_male: true, date_of_birth: '13/08/1986', occupation: 'cricket player', address: 'race course', pincode: '641001', emergency_number: '9973458231'})
member10.subscriptions << Subscription.create({start_date: Date.today-7.days, membership: m1})

member11 = facility.members.create({name: 'Hrithik', phone_number: '8979834578', email: 'hrithik@bar.com', is_male: true, date_of_birth: '31/05/1976', occupation: 'actor', address: 'rs puram', pincode: '641002', emergency_number: '9672666666'})
member11.subscriptions << Subscription.create({start_date: Date.today-5.days, membership: m1})

member12 = facility.members.create({name: 'Ishwarya', phone_number: '7722777777', email: 'ishwarya@bar.com', is_male: false, date_of_birth: '13/03/1989', occupation: 'student', address: 'ganapathy', pincode: '641028', emergency_number: '9003454574'})
member12.subscriptions << Subscription.create({start_date: Date.today-18.days, membership: m2})

member13 = facility.members.create({name: 'Jack', phone_number: '9003244672', email: 'jack@bar.com', is_male: true, date_of_birth: '13/03/1954', occupation: 'retired', address: 'race course', pincode: '641009', emergency_number: '8769871234'})
member13.subscriptions << Subscription.create({start_date: Date.today, membership: m2})

member14 = facility.members.create({name: 'Kavitha', phone_number: '9654012345', email: 'kavitha@bar.com', is_male: false, date_of_birth: '13/03/1986', occupation: 'IT', address: 'race course', pincode: '641009', emergency_number: '7654123456'})
member14.subscriptions << Subscription.create({start_date: Date.today-367.days, membership: m3})

member15 = facility.members.create({name: 'Lehman', phone_number: '7722344678', email: 'lehman@bar.com', is_male: true, date_of_birth: '13/03/1967', occupation: 'cricketer', address: 'race course', pincode: '641009', emergency_number: '9672846897'})
member15.subscriptions << Subscription.create({start_date: Date.today-32.days, membership: m1})

member16 = facility.members.create({name: 'Mahesh', phone_number: '8876512345', email: 'mahesh@bar.com', is_male: true, date_of_birth: '13/03/1986', occupation: 'Lawyer', address: 'race course', pincode: '641009', emergency_number: '8807401000'})
member16.subscriptions << Subscription.create({start_date: Date.today-27.days, membership: m1})

member17 = facility.members.create({name: 'Naveen', phone_number: '7711000555', email: 'naveen@bar.com', is_male: true, date_of_birth: '13/03/1991', occupation: 'student', address: 'race course', pincode: '641009', emergency_number: '967284397'})
member17.subscriptions << Subscription.create({start_date: Date.today-87.days, membership: m2})

member18 = facility.members.create({name: 'Osho', phone_number: '8934222444', email: 'osho@bar.com', is_male: false, date_of_birth: '13/03/1988', occupation: 'Fashion Designer', address: 'race course', pincode: '641009', emergency_number: '9672811111'})
member18.subscriptions << Subscription.create({start_date: Date.today-363.days, membership: m3})

member19 = facility.members.create({name: 'Prashanna', phone_number: '9003454575', email: 'prashanna@bar.com', is_male: true, date_of_birth: '13/03/1997', occupation: 'student', address: 'race course', pincode: '641009', emergency_number: '9443567274'})
member19.subscriptions << Subscription.create({start_date: Date.today, membership: m1})

member20 = facility.members.create({name: 'Quinton', phone_number: '7722348965', email: 'quinton@bar.com', is_male: true, date_of_birth: '13/03/1993', occupation: 'athelete', address: 'race course', pincode: '641009', emergency_number: '9672848931'})
member20.subscriptions << Subscription.create({start_date: Date.today-38.days, membership: m1})