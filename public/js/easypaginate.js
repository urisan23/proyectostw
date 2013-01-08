/*
 * 	Easy Paginate 1.0 - jQuery plugin
 *	written by Alen Grakalic	
 *	http://cssglobe.com/
 *
 *	Copyright (c) 2011 Alen Grakalic (http://cssglobe.com)
 *	Dual licensed under the MIT (MIT-LICENSE.txt)
 *	and GPL (GPL-LICENSE.txt) licenses.
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */

(function($) {
		  
	$.fn.easyPaginate = function(options){

		var defaults = {				
			step: 4,
			delay: 100,
			numeric: true,
			nextprev: false,
			auto:false,
			loop:false,
			pause:4000,
			clickstop:true,
			controls: 'pagination',
			current: 'current',
			randomstart: false
		}; 
		
		var options = $.extend(defaults, options); 
		var step = options.step;
		var lower, upper;
		var children = $(this).children();
		var count = children.length;
		var obj, next, prev;		
		var pages = Math.floor(count/step);
		var page = (options.randomstart) ? Math.floor(Math.random()*pages)+1 : 1;
		var timeout;
		var clicked = false;
		
		function show(){
			clearTimeout(timeout);
			lower = ((page-1) * step);
			upper = lower+step;
			$(children).each(function(i){
				var child = $(this);
				child.hide();
				if(i>=lower && i<upper){ setTimeout(function(){ child.fadeIn('fast') }, ( i-( Math.floor(i/step) * step) )*options.delay ); }
				if(options.nextprev){
					if(upper >= count) { next.fadeOut('fast'); } else { next.fadeIn('fast'); };
					if(lower >= 1) { prev.fadeIn('fast'); } else { prev.fadeOut('fast'); };
				};
			});	
			$('li','#'+ options.controls).removeClass(options.current);
			$('li[data-index="'+page+'"]','#'+ options.controls).addClass(options.current);
			
			if(options.auto){
				if(options.clickstop && clicked){}else{ timeout = setTimeout(auto,options.pause); };
			};
		};
		
		function auto(){
			if(options.loop) if(upper >= count){ page=0; show(); }
			if(upper < count){ page++; show(); }				
		};
		
		this.each(function(){ 
			
			obj = this;
			
			if(count>step){
								
				if((count/step) > pages) pages++;
				
        var div = $('<div class="pagination pagination-centered"></div>').insertAfter(obj);
				var ul = $('<ul id="'+ options.controls +'"></ul>').appendTo(div);
				
				if(options.nextprev){
					prev = $('<li ><a href="#">Anterior</a></li>')
						.appendTo(ul)
						.click(function(){
							clicked = true;
							page--;
							show();
						});
				}else{
          if (page == 0){
            dis = ' class = "disabled"';
            prev = $('<li'+dis+'><a href="#">Anterior</a></li>')
              .appendTo(ul)
              .click(function(){
                clicked = true;
                page--;
                show();
              });
          }
        };
				
				if(options.numeric){
					for(var i=1;i<=pages;i++){
					$('<li data-index="'+ i +'"><a href="#">'+ i +'</a></li>')
						.appendTo(ul)
						.click(function(){	
							clicked = true;
							page = $(this).attr('data-index');
							show();
						});					
					};				
				};
				
				if(options.nextprev){
					next = $('<li ><a href="#">Siguiente</a></li>')
						.appendTo(ul)
						.click(function(){
							clicked = true;			
							page++;
							show();
						});
				}else{
          if(page == pages){
            dis = ' class = "disabled"';
            next = $('<li'+dis+' ><a href="#">Siguiente</a></li>')
              .appendTo(ul)
              .click(function(){
                clicked = true;     
                page++;
                show();
              });
          }
        };
			
				show();
			};
		});	
		
	};	

})(jQuery);