import Nav from './components/nav';
import { BrowserRouter } from 'react-router-dom';
import Rout from './components/rout';

function App() {

  return (
    <>
      <BrowserRouter>
        <Nav />
        <Rout />
      </BrowserRouter>
    </>
  )
}

export default App;
