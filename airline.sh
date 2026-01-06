#!/bin/bash

while true
do
    echo "=================================="
    echo "     AIRLINE MANAGEMENT SYSTEM    "
    echo "=================================="
    echo "1. Add Flight"
    echo "2. View Flights"
    echo "3. Book Ticket"
    echo "4. View Bookings"
    echo "5. Cancel Booking"
    echo "6. Search Flight"
    echo "7. Exit"
    echo "Enter your choice:"
    read choice

    case $choice in

    1)
        echo "Enter Flight Number:"
        read fno
        echo "Enter Source:"
        read src
        echo "Enter Destination:"
        read dest
        echo "Enter Price:"
        read price
        echo "Enter Total Seats:"
        read seats

        echo "$fno | $src | $dest | $price | $seats" >> flights.txt
        echo "Flight Added Successfully!"
        ;;

    2)
        echo "Available Flights:"
        echo "FlightNo | Source | Destination | Price | Seats"
        cat flights.txt
        ;;

    3)
        echo "Enter Passenger Name:"
        read name
        echo "Enter CNIC / Passport:"
        read cnic
        echo "Enter Age:"
        read age
        echo "Enter Phone Number:"
        read phone
        echo "Enter Flight Number:"
        read fno

        if grep -q "^$fno " flights.txt
        then
            seats=$(grep "^$fno " flights.txt | awk -F'|' '{print $5}')

            if [ "$seats" -gt 0 ]
            then
                echo "$name | $cnic | $age | $phone | $fno" >> bookings.txt

                sed -i "/^$fno /s/| $seats/| $((seats-1))/" flights.txt

                echo "Ticket Booked Successfully!"
            else
                echo "No Seats Available!"
            fi
        else
            echo "Flight Not Found!"
        fi
        ;;

    4)
        echo "Booking Records:"
        echo "Name | CNIC | Age | Phone | FlightNo"
        cat bookings.txt
        ;;

    5)
        echo "Enter CNIC to Cancel Booking:"
        read cnic

        if grep -q "$cnic" bookings.txt
        then
            fno=$(grep "$cnic" bookings.txt | awk -F'|' '{print $5}')

            seats=$(grep "^$fno " flights.txt | awk -F'|' '{print $5}')
            sed -i "/^$fno /s/| $seats/| $((seats+1))/" flights.txt

            sed -i "/$cnic/d" bookings.txt
            echo "Booking Cancelled Successfully!"
        else
            echo "Booking Not Found!"
        fi
        ;;

    6)
        echo "Enter Source:"
        read src
        echo "Enter Destination:"
        read dest

        grep "$src" flights.txt | grep "$dest"
        ;;

    7)
        echo "Thank you for using Airline Management System"
        exit
        ;;

    *)
        echo "Invalid Choice"
        ;;
    esac
done
