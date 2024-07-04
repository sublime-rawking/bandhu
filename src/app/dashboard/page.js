

import React from 'react'
import Navbar from '@/app/dashboard/Navbar'
import UserTable from './userTable'

export default function Dashboard() {
    return (
        <div>
            <Navbar />
            <UserTable />
        </div>
    )
}
