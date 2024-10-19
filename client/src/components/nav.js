import React from 'react'

import { FaSearch } from "react-icons/fa";
import { FiLogIn } from "react-icons/fi";
import { CiUser } from "react-icons/ci";

import { Link } from 'react-router-dom';

import './nav.css'

const Nav = () => {

    const { isAuthenticated } = true; // TODO: Manage user authentication state here
    const user = null; // TODO: Manage user data here

    return (
        <>
        <div className='header'>
            {/* Alert Top Header (if relevent :3) */}
            {/* <div className='top_header'>
                <div className='icon'>
                    <SiOctopusdeploy />
                </div>
                <div className='info'>
                    <p>Insert an alert message here if needed :3</p>
                </div>
            </div> */}

            <div className='mid_header'>
                <div className='logo'>
                    <img src='image/logo.png' alt='logo'/>
                </div>

                <div className='search_box'>
                    <input type='text' value='' placeholder='Search'></input>
                    <button><FaSearch /></button>
                </div>
                
                <div className='user'>
                    <div className='icon'>
                        <FiLogIn />
                    </div>
                    <div className='btn'>
                        <button>Login</button>
                    </div>
                </div>
            </div>

            <div className='bottom_header'>
                <div className ='user_profile'>
                    {
                        // User Profile if logged in
                        isAuthenticated ?
                        <>
                            <div className='icon'>
                                <CiUser />
                            </div>
                            <div className='info'>
                                <h2>{ user.name }</h2>
                                <p>{ user.email }</p>
                            </div>
                        </>
                        :
                        // User Profile if not logged in
                        <>
                            <div className='icon'>
                                <CiUser />
                            </div>
                            <div className='info'>
                                <p>Guest (Please Login)</p>
                            </div>
                        </>
                    }
                </div>

                <div className='nav'>
                    <ul>
                        <li><Link to='/' className='link'>Home</Link></li>
                        <li><Link to='/tournaments' className='link'>Tournaments</Link></li>
                        <li><Link to='/games' className='link'>Games</Link></li>
                        <li><Link to='/contact' className='link'>Contact</Link></li>
                    </ul>
                </div>

                <div className='offer'>
                    <p>Create your own tournament</p>
                </div>
            </div>
        </div>
        </>
    )
}

export default Nav