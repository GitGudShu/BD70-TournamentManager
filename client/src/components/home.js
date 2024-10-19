import React, { useEffect, useState } from 'react'
import './home.css'

const Home = () => {

    const [backendData, setBackendData] = useState([{}]);

    useEffect(() => {
        fetch('/api/get_jeux')
        .then(response => response.json())
        .then(data => { setBackendData(data) }); 
    }, [])

    return (
        <>
        <div className='home'>
            <div className='top_banner'>
                
            </div>

            <div className='test'>
                {(typeof backendData === 'undefined') ? (
                    <p>Loading...</p>
                ) : (
                    backendData.map((game, i) => (
                        <div key={i}>
                            <p><strong>Name:</strong> {game.name}</p>
                            <p><strong>Min Players:</strong> {game.min_players}</p>
                            <p><strong>Max Players:</strong> {game.max_players}</p>
                            <p><strong>Type:</strong> {game.type}</p>
                            <p><strong>Rules:</strong> {game.rules}</p>
                            {game.image && (
                                <img src={`data:image/jpeg;base64,${game.image}`} alt={game.name} />
                            )}
                            <hr />
                        </div>
                    ))
                )}
            </div>
        </div>
        </>
    )
}

export default Home