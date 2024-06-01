'use client'
 
import { usePathname } from 'next/navigation'
import Link from "next/link";

export default function NavBar() {
    const pathname = usePathname();
    return (
        <nav>
            <ul className="flex">
                <li className='pr-1'>
                <Link href="/ads" className={`text-gray-300 ${pathname === '/ads' ? "bg-purple-900" : null} hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium pr-1`}>
                    Ads
                  </Link>
                </li>
                <li>
                <Link href="/reports" className={`text-gray-300 ${pathname === '/reports' ? "bg-purple-900" : null} hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium`}>
                    Reports
                  </Link>
                </li>
            </ul>
        </nav>
    );
}