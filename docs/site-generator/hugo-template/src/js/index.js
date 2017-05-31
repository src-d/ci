import setupMenu from './behaviours/menu'
import formatSourceCode from './components/source-code'

window.addEventListener('DOMContentLoaded', _ => {
    setupMenu('#menuToggle', '#menu')
    formatSourceCode('.project-container > .content pre > code')
})
