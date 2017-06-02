export default function formatSourceCode(selector) {
    const codeElements = [].slice.call(document.querySelectorAll(selector))
    codeElements.forEach(convertToCodeWindow)
}

function convertToCodeWindow(c) {
    const code = c.parentNode
    const codeWindowElement = document.createElement('div')
    codeWindowElement.className = 'projectCode'
    codeWindowElement.innerHTML = '<div class="projectCodeHeader"><h3></h3></div>'

    code.parentNode.insertBefore(codeWindowElement, code)
    codeWindowElement.appendChild(code)
}
