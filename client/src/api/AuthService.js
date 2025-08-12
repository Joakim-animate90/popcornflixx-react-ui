import apiClient, { setTokens, clearTokens } from "@config/apiConfig";

/**
 * AuthService module to handle authentication related API calls.
 */
const AuthService = {
  /**
   * Logs in the user.
   * @param {string} email - The user's email.
   * @param {string} password - The user's password.
   * @returns {Promise<Object>} The response data from the API.
   * @throws Will throw an error if the login fails.
   */
  login: async (email, password) => {
    try {
      const response = await apiClient.post('/auth/login/', { email, password });
      const { access, refresh, user } = response.data;
      
      // Store tokens and user data
      setTokens(access, refresh);
      localStorage.setItem('user', JSON.stringify(user));
      
      return response.data;
    } catch (error) {
      console.error('Error logging in:', error);
      throw new Error(
        'Login failed. Please check your credentials and try again.'
      );
    }
  },

  /**
   * Logs out the user.
   * @returns {Promise<Object>} The response data from the API.
   * @throws Will throw an error if the logout fails.
   */
  logout: async () => {
    try {
      const response = await apiClient.post('/user/logout');

      // Clear stored tokens and user data
      clearTokens();
      
      return response.data;
    } catch (error) {
      console.error('Error logging out:', error);
      // Clear tokens even if logout request fails
      clearTokens();
      throw new Error('Logout failed. Please try again.');
    }
  },

  /**
   * Registers a new user.
   * @param {string} username - The user's username.
   * @param {string} first_name - The user's first name.
   * @param {string} last_name - The user's last name.
   * @param {string} email - The user's email.
   * @param {string} password - The user's password.
   * @param {string} password_confirm - Password confirmation.
   * @returns {Promise<Object>} The response data from the API.
   * @throws Will throw an error if the registration fails.
   */
  register: async (username, first_name, last_name, email, password, password_confirm) => {
    try {
      const response = await apiClient.post('/auth/register/', { 
        email, 
        username, 
        first_name, 
        last_name, 
        password, 
        password_confirm 
      });
      
      // If registration returns tokens, store them
      if (response.data.access && response.data.refresh) {
        const { access, refresh, user } = response.data;
        setTokens(access, refresh);
        localStorage.setItem('user', JSON.stringify(user));
      }
      
      return response.data;
    } catch (error) {
      console.error('Error registering user:', error);
      throw new Error('Registration failed. Please try again.');
    }
  },

  /**
   * Gets the current user from localStorage.
   * @returns {Object|null} The current user object or null if not logged in.
   */
  getCurrentUser: () => {
    try {
      const userStr = localStorage.getItem('user');
      return userStr ? JSON.parse(userStr) : null;
    } catch (error) {
      console.error('Error parsing user data:', error);
      return null;
    }
  },

  /**
   * Checks if user is authenticated.
   * @returns {boolean} True if user is authenticated, false otherwise.
   */
  isAuthenticated: () => {
    const token = localStorage.getItem('access_token');
    const user = AuthService.getCurrentUser();
    return !!(token && user);
  },
};

export default AuthService;
