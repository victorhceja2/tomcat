window.getWidth = function() {return (window.innerWidth)?window.innerWidth:document.body.clientWidth;}
window.getHeight = function() {return (window.innerHeight)?window.innerHeight:document.body.clientHeight;}
window.parent._e3_print_graphic = function() {
    if (confirm('Deseas Imprimir este documento?')) {
        focus();
        print();
    }
}