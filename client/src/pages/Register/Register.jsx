import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ToastContainer, toast } from 'react-toastify';

import toastConfig from '@config/toastConfig';
import AuthService from '@api/AuthService';

const RegisterForm = () => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
  });
  const navigate = useNavigate();

  function handleChange(e) {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
  }

  async function handleSubmit(e) {
    e.preventDefault();

    try {
      await AuthService.register(
        formData.username,
        formData.first_name,
        formData.last_name,
        formData.email,
        formData.password,
        formData.password_confirm
      );
      toast.success('User registered. Proceed to login.', toastConfig);
      navigate('/login');
    } catch (error) {
      toast.error(error.message, toastConfig);
      console.error(error);
      setFormData({
        name: '',
        email: '',
        password: '',
      });
    }
  }


  return (
    <div className='form-container'>
      <form onSubmit={handleSubmit}>
        <h1>Join Letterboxd</h1>
        <label htmlFor='username'>Username</label>
        <input
          type='text'
          name='username'
          onChange={handleChange}
          value={formData.username}
        />
        <label htmlFor='first_name'>First Name</label>
        <input
          type='text'
          name='first_name'
          onChange={handleChange}
          value={formData.first_name}
        />
        <label htmlFor='last_name'>Last Name</label>
        <input
          type='text'   
          name='last_name'
          onChange={handleChange}
          value={formData.last_name}
        />
        <label htmlFor='email'>Email address</label>
        <input
          type='email'
          name='email'
          onChange={handleChange}
          value={formData.email}
        />
        <label htmlFor='password'>Password</label>
        <input
          type='password'
          name='password'
          onChange={handleChange}
          value={formData.password}
        />
        <label htmlFor='password_confirm'>Confirm Password</label>
        <input
          type='password'
          name='password_confirm'
          onChange={handleChange}
          value={formData.password_confirm}
        />
        <button type='submit'>Submit</button>
      </form>
      <ToastContainer {...toastConfig} />
    </div>
  );
};

export default RegisterForm;
