#!/usr/bin/expect
set ipaddress [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set fileToCopy [lindex $argv 3]
set destination [lindex $argv 4]

spawn ssh -o StrictHostKeyChecking=no $username@$ipaddress "mkdir -p $destination"
set pass "$password"
expect {
  password: {send "$pass\r"; exp_continue}
}
spawn scp -o StrictHostKeyChecking=no $fileToCopy $username@$ipaddress:$destination
expect {
  password: {send "$pass\r"; exp_continue}
}
