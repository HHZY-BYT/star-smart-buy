import { defineStore } from 'pinia'

export const useAdminStore = defineStore('admin', {
  state: () => ({
    token: localStorage.getItem('token') || '',
    adminId: localStorage.getItem('adminId') || '',
    username: localStorage.getItem('username') || ''
  }),

  getters: {
    isLoggedIn: (state) => !!state.token
  },

  actions: {
    setAuth(token, adminId, username) {
      this.token = token
      this.adminId = adminId
      this.username = username
      localStorage.setItem('token', token)
      localStorage.setItem('adminId', adminId)
      localStorage.setItem('username', username)
    },

    logout() {
      this.token = ''
      this.adminId = ''
      this.username = ''
      localStorage.removeItem('token')
      localStorage.removeItem('adminId')
      localStorage.removeItem('username')
    }
  }
})
